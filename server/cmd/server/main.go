package main

import (
	"github.com/ashwincreates/svas/pkg/certificate"
	"github.com/ashwincreates/svas/pkg/common/db"
	"github.com/ashwincreates/svas/pkg/vendors"
	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
)

func main() {
	viper.SetConfigFile("./pkg/common/envs/.env")
	viper.ReadInConfig()

	port := viper.Get("PORT").(string)
	dbUrl := viper.Get("DB_URL").(string)

	server := gin.Default()
	database := db.Init(dbUrl)

	vendors.RegisterRoutes(server, database)
	certificate.RegisterRoutes(server, database)

	server.Run(port)
}
