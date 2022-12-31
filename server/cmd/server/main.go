package main

import (
	"github.com/ashwincreates/svas/pkg/area"
	"github.com/ashwincreates/svas/pkg/certificate"
	"github.com/ashwincreates/svas/pkg/common/db"
	"github.com/ashwincreates/svas/pkg/license"
	"github.com/ashwincreates/svas/pkg/vendors"
	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
	"github.com/gin-contrib/cors"
)

func main() {
	viper.SetConfigFile("./pkg/common/envs/.env")
	viper.ReadInConfig()

	port := viper.Get("PORT").(string)
	dbUrl := viper.Get("DB_URL").(string)

	server := gin.Default()
	database := db.Init(dbUrl)

	server.Use(cors.New(cors.Config{
		AllowAllOrigins: true,
		AllowCredentials: true,
	}))

	vendors.RegisterRoutes(server, database)
	certificate.RegisterRoutes(server, database)
	area.RegisterRoutes(server, database)
	license.RegisterRoutes(server, database)

	server.Run(port)
}
