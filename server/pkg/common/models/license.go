package models

import (
	"time"

	"gorm.io/gorm"
)

type License struct {
	gorm.Model
	ValidTill time.Time
	VendorID uint
	AreaID uint
	Area Area 
	Vendor Vendor
}
