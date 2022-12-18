package vendors

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/auth"
	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

type RegisterBody struct {
	Email    string `json:"email"`
	Name     string `json:"name"`
	Password string `json:"password"`
}

func (h vendorHandler) RegisterVendor(c *gin.Context) {
	body := RegisterBody{}

	if err := c.BindJSON(&body); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	var vendor models.Vendor

	if h.DB.First(&vendor, "email = ?", body.Email); vendor.ID != 0 {
		c.AbortWithStatus(http.StatusConflict)
		return
	}

	vendor.Name = body.Name
	vendor.Password = body.Password
	vendor.Email = body.Email

	if result := h.DB.Create(&vendor); result == nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
		return
	}

	token, _ := auth.GenerateToken(vendor)

	c.JSON(http.StatusCreated, struct {
		Id    uint
		Token string
	}{
		vendor.ID,
		token,
	})
}
