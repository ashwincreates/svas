package vendors

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type vendorHandler struct {
	DB *gorm.DB
}

func RegisterRoutes(server *gin.Engine, db *gorm.DB) {
	h := &vendorHandler{
		DB: db,
	}
	routes := server.Group("/api/vendor")
	routes.POST("/register", h.RegisterVendor)
	routes.POST("/login", h.LoginVendor)
}
