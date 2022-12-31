package license

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type licenseHandler struct {
	DB *gorm.DB
}

func RegisterRoutes (server *gin.Engine, db *gorm.DB) {
	h := &licenseHandler{
		DB: db,
	}

	routes := server.Group("/api/license")

	routes.POST("/create", h.CreateLicense)
	routes.POST("/activate/:license_id", h.ActivateLicense)
	routes.POST("/renew/:license_id/:valid_till", h.RenewLicense)
	routes.GET("/retrieve/:vendor_id", h.RetrieveLicense)
}
