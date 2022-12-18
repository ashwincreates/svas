package vendors

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

type LoginBody struct {
	Email string `json:"email"`
	Password string `json:"password"`
}

func (h vendorHandler) LoginVendor(c *gin.Context) {
	body := LoginBody{}

	if err := c.BindJSON(&body); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	var vendor models.Vendor
	
	if result := h.DB.First(&vendor, "email = ?", body.Email); result.Error != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	// Token Handling not done, to be using headers

	if body.Password != vendor.Password {
		c.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	c.JSON(http.StatusAccepted, struct {
		ID uint `json:"id"`
	}{
		vendor.ID,
	})
}
