package models

import "gorm.io/gorm"

type Area struct {
	gorm.Model
	Name      string
	Address   string
	Longitude float64
	Latitude  float64
	Radius    uint
	Limit     uint
	City      string
}
