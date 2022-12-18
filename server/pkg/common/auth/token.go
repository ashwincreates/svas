package auth

import (
	"errors"
	"fmt"
	"time"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/golang-jwt/jwt"
	"github.com/spf13/viper"
)

var jwtKey = viper.Get("JWT_KEY")

type authClaims struct {
	jwt.StandardClaims
	UserId uint `json:"usedId"`
}

func GenerateToken(vendor models.Vendor) (string, error) {
	expiresAt := time.Now().Add(24 * time.Hour).Unix()
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, authClaims {
		StandardClaims: jwt.StandardClaims {
			Subject: vendor.Name,
			ExpiresAt: expiresAt,
		},
	})

	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func validateToken(tokenString string) (uint, string, error) {
	var claims authClaims
	token, err := jwt.ParseWithClaims(tokenString, &claims, func (token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return jwtKey, nil
	})
	if err != nil {
		return 0, "", err
	}
	if !token.Valid {
		return 0, "", errors.New("invalid token")
	}

	id := claims.UserId
	username := claims.Subject
	return id, username, nil
}
