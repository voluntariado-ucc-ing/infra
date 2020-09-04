use voluntariado_ing;

create table directions if not exists
(
	direction_id bigserial not null
		constraint directions_pk
			primary key,
	street varchar(256),
	number integer,
	details varchar(512),
	city varchar(64),
	postal_code integer,
	locality varchar(64)
);

alter table directions owner to postgres;

create unique index directions_direction_id_uindex
	on directions (direction_id);

create table permissions if not exists
(
	permission_id bigserial not null
		constraint permissions_pk
			primary key,
	name varchar(256) not null
);

alter table permissions owner to postgres;

create unique index permissions_permission_id_uindex
	on permissions (permission_id);

create table medical_info if not exists
(
	medical_info_id bigserial not null
		constraint medical_info_pk
			primary key,
	data json
);

alter table medical_info owner to postgres;

create unique index medical_info_medical_info_id_uindex
	on medical_info (medical_info_id);

create table roles if not exists
(
	role_id bigserial not null
		constraint roles_pk
			primary key,
	name varchar(256) not null
);

alter table roles owner to postgres;

create unique index roles_role_id_uindex
	on roles (role_id);

create table roles_permissions if not exists
(
	role_id bigint
		constraint roles_permissions_roles_role_id_fk
			references roles,
	permission_id bigint
		constraint roles_permissions_permissions_permission_id_fk
			references permissions
);

alter table roles_permissions owner to postgres;

create table donation_types if not exists
(
	donation_type_id bigserial not null
		constraint donation_types_pk
			primary key,
	name varchar(256)
);

alter table donation_types owner to postgres;

create unique index donation_types_donation_type_id_uindex
	on donation_types (donation_type_id);

create table volunteer_details if not exists
(
	volunteer_details_id bigserial not null
		constraint volunteer_details_pk
			primary key,
	contact_mail varchar(256),
	phone_number varchar(64),
	photo_url varchar(1024),
	birth_date date,
	has_car boolean,
	direction_id bigint
		constraint volunteer_details_directions_direction_id_fk
			references directions,
	university varchar(64),
	career varchar(64),
	career_year integer,
	works integer,
	career_condition varchar(16)
);

alter table volunteer_details owner to postgres;

create unique index volunteer_details_volunteer_details_id_uindex
	on volunteer_details (volunteer_details_id);

create table volunteers if not exists
(
	volunteer_id bigserial not null
		constraint volunteers_pk
			primary key,
	first_name varchar(256),
	last_name varchar(256),
	username varchar(256) not null,
	document_id varchar(16) not null,
	status bigint,
	profile_id bigint
		constraint volunteers_volunteer_details_volunteer_details_id_fk
			references volunteer_details,
	password varchar(256),
	medical_info_id bigint
		constraint volunteers_medical_info_medical_info_id_fk
			references medical_info
);

alter table volunteers owner to postgres;

create unique index volunteers_username_uindex
	on volunteers (username);

create unique index volunteers_volunteer_id_uindex
	on volunteers (volunteer_id);

create table donators if not exists
(
	donator_id bigserial not null
		constraint donators_pk
			primary key,
	mail varchar(256) not null,
	first_name varchar(256),
	last_name varchar(256),
	phone_number varchar(64)
);

alter table donators owner to postgres;

create unique index donators_donator_id_uindex
	on donators (donator_id);

create unique index donators_mail_uindex
	on donators (mail);

create table donations if not exists
(
	donation_id bigserial not null
		constraint donations_pk
			primary key,
	quantity integer,
	unit varchar(64),
	description varchar(256),
	type_id bigint
		constraint donations_donation_types_donation_type_id_fk
			references donation_types,
	donator_id bigint
		constraint donations_donators_donator_id_fk
			references donators,
	direction_id bigint
		constraint donations_directions_direction_id_fk
			references directions,
	donation_date date,
	status varchar(64),
	element varchar(128)
);

alter table donations owner to postgres;

create unique index donations_donation_id_uindex
	on donations (donation_id);

create table volunteers_roles if not exists
(
	volunteer_id bigint
		constraint volunteers_roles_volunteers_volunteer_id_fk
			references volunteers,
	role_id bigint
		constraint volunteers_roles_roles_role_id_fk
			references roles
);

alter table volunteers_roles owner to postgres;

create table events if not exists
(
	event_id bigserial not null
		constraint events_pk
			primary key,
	title varchar(64),
	description varchar(256),
	init_time time,
	finish_time time,
	event_date date,
	owner_id bigint
		constraint events_volunteers_volunteer_id_fk
			references volunteers
);

alter table events owner to postgres;

create unique index events_event_id_uindex
	on events (event_id);

create table meetings if not exists
(
	meeting_id bigserial not null
		constraint meetings_pk
			primary key,
	title varchar(256),
	description varchar(1024),
	date date,
	init_time time,
	finish_time time,
	creator_id bigint
		constraint meetings_volunteers_volunteer_id_fk
			references volunteers,
	comments varchar(1024)
);

comment on column meetings.comments is 'Conclusiones sacadas en la meeting.
Seteado por el organizador siempre';

alter table meetings owner to postgres;

create unique index meetings_meeting_id_uindex
	on meetings (meeting_id);

create table volunteers_meetings if not exists
(
	volunteer_id bigint
		constraint volunteers_meetings_volunteers_volunteer_id_fk
			references volunteers,
	meeting_id bigint
		constraint volunteers_meetings_meetings_meeting_id_fk
			references meetings
);

alter table volunteers_meetings owner to postgres;

create table tasks if not exists
(
	task_id bigserial not null
		constraint tasks_pk
			primary key,
	title varchar(64),
	description varchar(512),
	event_id bigint
		constraint tasks_events_event_id_fk
			references events,
	task_state integer,
	sits integer
);

alter table tasks owner to postgres;

create unique index tasks_task_id_uindex
	on tasks (task_id);

create table volunteers_tasks if not exists
(
	volunteer_id bigint
		constraint volunteers_tasks_volunteers_volunteer_id_fk
			references volunteers,
	task_id integer
		constraint volunteers_tasks_tasks_task_id_fk
			references tasks
);

alter table volunteers_tasks owner to postgres;

