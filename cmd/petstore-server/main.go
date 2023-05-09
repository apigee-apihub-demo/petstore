// Copyright 2023 Google LLC. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// pet represents data about a pet.
type pet struct {
	ID   string `json:"id"`
	Name string `json:"name"`
	Tag  string `json:"tag"`
}

// pets slice to seed pet data.
var pets = []pet{
	{ID: "1", Name: "Tardar Sauce", Tag: "cat"},
	{ID: "2", Name: "Bo", Tag: "dog"},
	{ID: "3", Name: "Toto", Tag: "dog"},
}

func main() {
	router := gin.Default()
	router.GET("/v1/pets", getPets)
	router.GET("/v1/pets/:id", getPetByID)
	router.POST("/v1/pets", postPets)

	router.Run("0.0.0.0:8080")
}

// getPets responds with the list of all pets as JSON.
func getPets(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, pets)
}

// postPets adds a pet from JSON received in the request body.
func postPets(c *gin.Context) {
	var newpet pet

	// Call BindJSON to bind the received JSON to newpet.
	if err := c.BindJSON(&newpet); err != nil {
		return
	}

	// Add the new pet to the slice.
	pets = append(pets, newpet)
	c.IndentedJSON(http.StatusCreated, newpet)
}

// getPetByID locates the pet whose ID value matches the id
// parameter sent by the client, then returns that pet as a response.
func getPetByID(c *gin.Context) {
	id := c.Param("id")

	// Loop through the list of pets, looking for
	// a pet whose ID value matches the parameter.
	for _, a := range pets {
		if a.ID == id {
			c.IndentedJSON(http.StatusOK, a)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{
		"code":    http.StatusNotFound,
		"message": "pet not found",
	})
}
