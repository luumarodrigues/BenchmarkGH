#!/bin/bash
set -e

# Debug: List files and directories
ls -lR /github/workspace
cd /github/workspace

# Inputs
BENCH_MAIN=${INPUT_BENCH_MAIN:-bench-main.txt}
BENCH_CURRENT=${INPUT_BENCH_CURRENT:-bench-current.txt}
AZURE_OPENAI_KEY=${INPUT_AZURE_OPENAI_KEY}
AZURE_OPENAI_ENDPOINT=${INPUT_AZURE_OPENAI_ENDPOINT}
PR_NUMBER=${INPUT_PR_NUMBER}
GITHUB_TOKEN=${INPUT_GITHUB_TOKEN}
GITHUB_REPOSITORY=${INPUT_GITHUB_REPOSITORY}

echo "BENCH_MAIN: $BENCH_MAIN"
echo "BENCH_CURRENT: $BENCH_CURRENT"
ls -l "$BENCH_MAIN" "$BENCH_CURRENT"

# Debug: List all INPUT_ variables
env | grep '^INPUT_'

# Run benchstat
benchstat "$BENCH_MAIN" "$BENCH_CURRENT" > result.txt

# Ensure UTF-8
iconv -f utf-8 -t utf-8 result.txt > result_utf8.txt

# Prepare JSON payload
json_payload=$(jq -n --rawfile content result_utf8.txt '{
  "messages": [
    { "role": "system", "content": "Você é um assistente de análise de benchmark. Analise o resultado do benchstat abaixo e explique, de forma simples e direta, se houve melhora, piora ou se está igual em desempenho, uso de memória e alocações. Resuma em poucas frases." },
    { "role": "user", "content": $content }
  ],
  "max_tokens": 200,
  "temperature": 0.5,
  "top_p": 0.95
}')

# Call Azure OpenAI
response=$(curl -s -w "%{http_code}" -o response.json \
  -X POST "$AZURE_OPENAI_ENDPOINT" \
  -H 'Content-Type: application/json' \
  -H "api-key: $AZURE_OPENAI_KEY" \
  -d "$json_payload")

if [ "$response" = "200" ]; then
  jq -r '.choices[0].message.content' response.json > opencomment.md
else
  echo "Erro ao chamar o modelo: $response" > opencomment.md
  cat response.json >> opencomment.md
fi

cat opencomment.md

# Optionally, create PR comment if PR_NUMBER and GITHUB_TOKEN are set
echo "GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
if [ -n "$PR_NUMBER" ] && [ -n "$GITHUB_TOKEN" ] && [ -n "$GITHUB_REPOSITORY" ]; then
  COMMENT_BODY=$(echo -e "## Resultados do Benchmark\n\n\
\`\`\`\n$(cat result.txt)\n\`\`\`\n\n## Análise do resultado\n\n$(cat opencomment.md)")
  jq -n --arg body "$COMMENT_BODY" '{body: $body}' > payload.json
  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    --data @payload.json \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR_NUMBER/comments" > github_response.json
  cat github_response.json
fi
