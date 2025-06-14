# BenchmarkGH

Projeto Go para benchmarking e comparação de algoritmos de ordenação.

## Como Executar

Para rodar o programa principal:

```sh
go run app/main.go
```

## Testes e Benchmark

Execute os testes de benchmarks com:

```sh
go test -count=10 -cpu=1,2,4 -benchmem -run="" -bench .* ./... > bench-current.txt
```

### Instalar Benchstat

Para analisar os resultados dos benchmarks:

```sh
go install golang.org/x/perf/cmd/benchstat@latest
```

### Executar Benchstat

```sh
benchstat main=bench-main.txt current=bench-current.txt
```

## Estrutura do Projeto

- `app/main.go`: Implementação dos algoritmos de ordenação.
- `app/sort_test.go`: Benchmarks dos algoritmos.

## Exemplo de Uso

```go
arr := []int{64, 34, 25, 12, 22, 11, 90}
ordenado := Sort(arr)
fmt.Println(ordenado)
```

