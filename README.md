# TDC24


## Rodar o Projeto

**Execute o programa:**

```sh
go run app/main.go
```

## Testes e Benchmark

Para rodar os testes e benchmarks, utilize o comando abaixo:

```sh
go test -count=10 -cpu=1,2,4 -benchmem -run="" -bench ^*$ ./...
```

### Instalar Benchstat
```sh
go install golang.org/x/perf/cmd/benchstat@latest
```