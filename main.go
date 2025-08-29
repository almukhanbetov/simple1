package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.POST("/login", func(c *gin.Context) {
		var credentials struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}
		if err := c.ShouldBindJSON(&credentials); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный формат запроса"})
			return
		}

		if credentials.Username == "admin" && credentials.Password == "password123" {
			c.JSON(http.StatusOK, gin.H{"message": "Успешный вход"})
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"message": "Неверный логин или пароль"})
		}
	})
	router.Run(":8185")
}
