package util

import "time"

func ValidTillDate(createdAt time.Time, months uint) (validTill time.Time) {
	validTill = createdAt.AddDate(0, int(months), 0)	
	return validTill
}
