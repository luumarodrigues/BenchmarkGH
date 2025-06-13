package main

import "fmt"

// Algoritmo bubbleSort ordena um slice de inteiros
func Sort(arr []int) []int {
	n := len(arr)
	// Percorre o slice comparando o elemento ao lado e trocando de lugar se necessário
	for i := 0; i < n-1; i++ {
		for currentIndex := 0; currentIndex < n-i-1; currentIndex++ {
			if arr[currentIndex] > arr[currentIndex+1] {
				arr[currentIndex], arr[currentIndex+1] = arr[currentIndex+1], arr[currentIndex]
			}
		}
	}
	return arr
}

func main() {
	arr := []int{64, 34, 25, 12, 22, 11, 90}
	fmt.Println("Array antes de ordenar:", arr)
	arr = Sort(arr)
	fmt.Println("Array depois de ordenar:", arr)
}
