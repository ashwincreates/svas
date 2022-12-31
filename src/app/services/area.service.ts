import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, tap } from 'rxjs';

@Injectable({
	providedIn: 'root'
})
export class AreaService {

	private areaUrl = "http://localhost:8080/api/area"

	constructor(private http: HttpClient) { }

	getArea(): Observable<AreaJson[]> {
		let areasReq: Observable<AreaJson[]> = this.http.get<AreaJson[]>(this.areaUrl + '/get/jabalpur')
		areasReq
			.pipe(
				tap(() => console.log("Fetching Areas")),
				catchError(err => {
					console.log(err)
					return []
				}),
			)
		return areasReq;
	}

	createArea(area: Area): Observable<Object> {
		let body = {
			'name': area.name,
			'address': area.address,
			'long': area.center.lng,
			'lat': area.center.lat,
			'radius': area.radius,
			'limit': 100,
			'city': 'jabalpur'
		}
		let req: Observable<Object> = this.http.post(this.areaUrl + '/create', JSON.stringify(body))
		req
			.pipe(
				tap(() => console.log("Adding Areas")),
				catchError(err => {
					console.log(err)
					return []
				}),
			)
		return req;
	}

	updateArea(area: Area): Observable<Object> {
		let body = {
			'name': area.name,
			'address': area.address,
			'long': area.center.lng,
			'lat': area.center.lat,
			'radius': area.radius,
			'limit': 100,
			'city': 'jabalpur'
		}

		let req: Observable<Object> = this.http.post(this.areaUrl + `/update/${area.id}`, JSON.stringify(body))
		req
			.pipe(
				tap(() => console.log("Updating Areas")),
				catchError(err => {
					console.log(err)
					return []
				}),
			)
		return req;
	}

	deleteArea(area: Area): Observable<Object> {
		let req: Observable<Object> = this.http.post(this.areaUrl + `/delete/${area.id}`, '')
		req
			.pipe(
				tap(() => console.log("Updating Areas")),
				catchError(err => {
					console.log(err)
					return []
				}),
			)
		return req;
	}
}

interface AreaJson {
	Address: string
	City: string,
	CreatedAt: string,
	DeletedAt: string | null,
	ID: number,
	Latitude: number,
	Longitude: number,
	Name: string,
	Radius: number,
	UpdatedAt: string
}

export interface Area {
	id: number
	name: string
	address: string
	center: google.maps.LatLngLiteral
	radius: number
}
