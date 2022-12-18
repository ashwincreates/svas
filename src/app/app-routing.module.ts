import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DashboardComponent } from './dashboard/dashboard.component';
import { FeedbackComponent } from './feedback/feedback.component';
import { LocationsComponent } from './locations/locations.component';
import { LookupComponent } from './lookup/lookup.component';
import { RequestsComponent } from './requests/requests.component';

const routes: Routes = [
    { 
        path: 'dashboard',
        component: DashboardComponent, 
        children: [
            {path: 'lookup', component: LookupComponent},
            {path: 'requests', component: RequestsComponent},
            {path: 'locations', component: LocationsComponent},
            {path: 'feedback', component: FeedbackComponent},
            {path: '**', redirectTo: 'lookup'}
        ]
    }, 
    { path: '', redirectTo: 'dashboard', pathMatch: 'full'}
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class AppRoutingModule { }
