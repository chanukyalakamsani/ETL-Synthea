/*********************************************************************************
# Copyright 2017-11 Observational Health Data Sciences and Informatics
#
#
# Licensed under the Apache License, Version 2.0 (the "License")
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #           #######      #####
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####
 #     # #     # #     # #          #       #     # #     #    #    #       # ###       #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #     #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###  #####


postgresql script to create OMOP common data model version 5.3

last revised: 14-June-2018

Authors:  Patrick Ryan, Christian Reich, Clair Blacketer


*************************/


/**************************

Standardized meta-data

***************************/

if object_id('@cdm_schema.cdm_source', 'U')  is not null drop table @cdm_schema.cdm_source;
CREATE TABLE @cdm_schema.cdm_source
(
  cdm_source_name					        VARCHAR(255)	NOT NULL ,
  cdm_source_abbreviation			    VARCHAR(25)		NULL ,
  cdm_holder							        VARCHAR(255)	NULL ,
  source_description					    VARCHAR(255)	NULL ,
  source_documentation_reference	VARCHAR(255)	NULL ,
  cdm_etl_reference					      VARCHAR(255)	NULL ,
  source_release_date				      DATE			    NULL ,
  cdm_release_date					      DATE			    NULL ,
  cdm_version						          VARCHAR(10)		NULL ,
  vocabulary_version					    VARCHAR(20)		NULL
)
;

if object_id('@cdm_schema.metadata', 'U')  is not null drop table @cdm_schema.metadata;
CREATE TABLE @cdm_schema.metadata
(
  metadata_concept_id       INTEGER       NOT NULL ,
  metadata_type_concept_id  INTEGER       NOT NULL ,
  name                      VARCHAR(250)  NOT NULL ,
  value_as_string           VARCHAR(255)  NULL ,
  value_as_concept_id       INTEGER       NULL ,
  metadata_date             DATE          NULL ,
  metadata_datetime         DATE      NULL
)
;


/************************

Standardized clinical data

************************/

if object_id('@cdm_schema.person', 'U')  is not null drop table @cdm_schema.person;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.person
(
   person_id						BIGINT	  	NOT NULL , 
  gender_concept_id				INTEGER	  	NOT NULL ,
  year_of_birth					INTEGER	  	NOT NULL ,
  month_of_birth				INTEGER	  	NULL,
  day_of_birth					INTEGER	  	NULL,
  birth_datetime				TIMESTAMP	NULL,
  death_datetime				TIMESTAMP	NULL,
  race_concept_id				INTEGER		NOT NULL,
  ethnicity_concept_id			INTEGER	  	NOT NULL,
  location_id					BIGINT		NULL,
  provider_id					BIGINT		NULL,
  care_site_id					BIGINT		NULL,
  person_source_value			VARCHAR(50)	NULL,
  gender_source_value			VARCHAR(50) NULL,
  gender_source_concept_id	  	INTEGER		NOT NULL,
  race_source_value				VARCHAR(50) NULL,
  race_source_concept_id		INTEGER		NOT NULL,
  ethnicity_source_value		VARCHAR(50) NULL,
  ethnicity_source_concept_id	INTEGER		NOT NULL
)
;

if object_id('@cdm_schema.observation_period', 'U')  is not null drop table @cdm_schema.observation_period;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.observation_period
(
  observation_period_id				BIGINT		NOT NULL ,
  person_id							BIGINT		NOT NULL ,
  observation_period_start_date		DATE		NOT NULL ,
  observation_period_end_date		DATE		NOT NULL ,
  period_type_concept_id			INTEGER		NOT NULL
)
;

if object_id('@cdm_schema.specimen', 'U')  is not null drop table @cdm_schema.specimen;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.specimen
(
  specimen_id					BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  specimen_concept_id			INTEGER			NOT NULL ,
  specimen_type_concept_id		INTEGER			NOT NULL ,
  specimen_date					DATE			NULL ,
  specimen_datetime				TIMESTAMP		NOT NULL ,
  quantity						NUMERIC			NULL ,
  unit_concept_id				INTEGER			NULL ,
  anatomic_site_concept_id		INTEGER			NOT NULL ,
  disease_status_concept_id		INTEGER			NOT NULL ,
  specimen_source_id			VARCHAR(50)		NULL ,
  specimen_source_value			VARCHAR(50)		NULL ,
  unit_source_value				VARCHAR(50)		NULL ,
  anatomic_site_source_value	VARCHAR(50)		NULL ,
  disease_status_source_value	VARCHAR(50)		NULL
)
;

if object_id('@cdm_schema.visit_occurrence', 'U')  is not null drop table @cdm_schema.visit_occurrence;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.visit_occurrence
(
  visit_occurrence_id			BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  visit_concept_id				INTEGER			NOT NULL ,
  visit_start_date				DATE			NULL ,
  visit_start_datetime			TIMESTAMP		NOT NULL ,
  visit_end_date				DATE			NULL ,
  visit_end_datetime			TIMESTAMP		NOT NULL ,
  visit_type_concept_id			INTEGER			NOT NULL ,
  provider_id					BIGINT			NULL,
  care_site_id					BIGINT			NULL,
  visit_source_value			VARCHAR(50)		NULL,
  visit_source_concept_id		INTEGER			NOT NULL ,
  admitting_source_concept_id	INTEGER			NULL ,
  admitting_source_value		VARCHAR(50)	    NULL ,
  discharge_to_source_value		VARCHAR(50)		NULL ,
  discharge_to_concept_id		INTEGER   		NOT NULL ,
  preceding_visit_occurrence_id	BIGINT 			NULL
)
;

if object_id('@cdm_schema.visit_detail', 'U')  is not null drop table @cdm_schema.visit_detail;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.visit_detail
(
  visit_detail_id                    BIGINT      NOT NULL ,
  person_id                          BIGINT      NOT NULL ,
  visit_detail_concept_id            INTEGER     NOT NULL ,
  visit_detail_start_date            DATE        NULL ,
  visit_detail_start_datetime        TIMESTAMP   NOT NULL ,
  visit_detail_end_date              DATE        NULL ,
  visit_detail_end_datetime          TIMESTAMP   NOT NULL ,
  visit_detail_type_concept_id       INTEGER     NOT NULL ,
  provider_id                        BIGINT      NULL ,
  care_site_id                       BIGINT      NULL ,
  discharge_to_concept_id            INTEGER     NOT NULL ,
  admitted_from_concept_id           INTEGER     NOT NULL , 
  admitted_from_source_value         VARCHAR(50) NULL ,
  visit_detail_source_value          VARCHAR(50) NULL ,
  visit_detail_source_concept_id     INTEGER     NOT NULL ,
  discharge_to_source_value          VARCHAR(50) NULL ,
  preceding_visit_detail_id          BIGINT      NULL ,
  visit_detail_parent_id             BIGINT      NULL ,
  visit_occurrence_id                BIGINT      NOT NULL
)
;

if object_id('@cdm_schema.procedure_occurrence', 'U')  is not null drop table @cdm_schema.procedure_occurrence;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.procedure_occurrence
(
  procedure_occurrence_id		BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  procedure_concept_id			INTEGER			NOT NULL ,
  procedure_date				DATE			NULL ,
  procedure_datetime			TIMESTAMP		NOT NULL ,
  procedure_type_concept_id		INTEGER			NOT NULL ,
  modifier_concept_id			INTEGER			NOT NULL ,
  quantity						INTEGER			NULL ,
  provider_id					BIGINT			NULL ,
  visit_occurrence_id			BIGINT			NULL ,
  visit_detail_id             	BIGINT      	NULL ,
  procedure_source_value		VARCHAR(50)		NULL ,
  procedure_source_concept_id	INTEGER			NOT NULL ,
  modifier_source_value		    VARCHAR(50)		NULL 
)
;

if object_id('@cdm_schema.drug_exposure', 'U')  is not null drop table @cdm_schema.drug_exposure;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.drug_exposure
(
  drug_exposure_id				BIGINT			 	NOT NULL ,
  person_id						BIGINT			 	NOT NULL ,
  drug_concept_id				INTEGER			  	NOT NULL ,
  drug_exposure_start_date		DATE			    NULL ,
  drug_exposure_start_datetime	TIMESTAMP		 	NOT NULL ,
  drug_exposure_end_date		DATE			    NULL ,
  drug_exposure_end_datetime	TIMESTAMP		  	NOT NULL ,
  verbatim_end_date				DATE			    NULL ,
  drug_type_concept_id			INTEGER			  	NOT NULL ,
  stop_reason					VARCHAR(20)			NULL ,
  refills						INTEGER		  		NULL ,
  quantity						NUMERIC			    NULL ,
  days_supply					INTEGER		  		NULL ,
  sig							TEXT				NULL ,
  route_concept_id				INTEGER				NOT NULL ,
  lot_number					VARCHAR(50)	 		NULL ,
  provider_id					BIGINT			  	NULL ,
  visit_occurrence_id			BIGINT			  	NULL ,
  visit_detail_id               BIGINT       		NULL ,
  drug_source_value				VARCHAR(50)	  		NULL ,
  drug_source_concept_id		INTEGER			  	NOT NULL ,
  route_source_value			VARCHAR(50)	  		NULL ,
  dose_unit_source_value		VARCHAR(50)	  		NULL
)
;

if object_id('@cdm_schema.device_exposure', 'U')  is not null drop table @cdm_schema.device_exposure;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.device_exposure
(
  device_exposure_id			    BIGINT		  	NOT NULL ,
  person_id						    BIGINT			NOT NULL ,
  device_concept_id			        INTEGER			NOT NULL ,
  device_exposure_start_date	    DATE			NULL ,
  device_exposure_start_datetime	TIMESTAMP		NOT NULL ,
  device_exposure_end_date		    DATE			NULL ,
  device_exposure_end_datetime    	TIMESTAMP		NULL ,
  device_type_concept_id		    INTEGER			NOT NULL ,
  unique_device_id			        VARCHAR(50)		NULL ,
  quantity						    INTEGER			NULL ,
  provider_id					    BIGINT			NULL ,
  visit_occurrence_id			    BIGINT			NULL ,
  visit_detail_id                 	BIGINT       	NULL ,
  device_source_value			    VARCHAR(100)	NULL ,
  device_source_concept_id		    INTEGER			NOT NULL
)
;

if object_id('@cdm_schema.condition_occurrence', 'U')  is not null drop table @cdm_schema.condition_occurrence;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.condition_occurrence
(
  condition_occurrence_id		BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  condition_concept_id			INTEGER			NOT NULL ,
  condition_start_date			DATE			NULL ,
  condition_start_datetime		TIMESTAMP		NOT NULL ,
  condition_end_date			DATE			NULL ,
  condition_end_datetime		TIMESTAMP		NULL ,
  condition_type_concept_id		INTEGER			NOT NULL ,
  condition_status_concept_id	INTEGER			NOT NULL ,
  stop_reason					VARCHAR(20)		NULL ,
  provider_id					BIGINT			NULL ,
  visit_occurrence_id			BIGINT			NULL ,
  visit_detail_id               BIGINT	     	NULL ,
  condition_source_value		VARCHAR(50)		NULL ,
  condition_source_concept_id	INTEGER			NOT NULL ,
  condition_status_source_value	VARCHAR(50)		NULL
)
;

if object_id('@cdm_schema.measurement', 'U')  is not null drop table @cdm_schema.measurement;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.measurement
(
  measurement_id				BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  measurement_concept_id		INTEGER			NOT NULL ,
  measurement_date				DATE			NULL ,
  measurement_datetime			TIMESTAMP		NOT NULL ,
  measurement_time              VARCHAR(10) 	NULL,
  measurement_type_concept_id	INTEGER			NOT NULL ,
  operator_concept_id			INTEGER			NULL ,
  value_as_number				NUMERIC			NULL ,
  value_as_concept_id			INTEGER			NULL ,
  unit_concept_id				INTEGER			NULL ,
  range_low					    NUMERIC			NULL ,
  range_high					NUMERIC			NULL ,
  provider_id					BIGINT			NULL ,
  visit_occurrence_id			BIGINT			NULL ,
  visit_detail_id               BIGINT	     	NULL ,
  measurement_source_value		VARCHAR(50)		NULL ,
  measurement_source_concept_id	INTEGER			NOT NULL ,
  unit_source_value				VARCHAR(50)		NULL ,
  value_source_value			VARCHAR(50)		NULL
)
;

if object_id('@cdm_schema.note', 'U')  is not null drop table @cdm_schema.note;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.note
(
  note_id						BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  note_event_id         		BIGINT      	NULL , 
  note_event_field_concept_id	INTEGER 		NOT NULL , 
  note_date						DATE			NULL ,
  note_datetime					TIMESTAMP		NOT NULL ,
  note_type_concept_id			INTEGER			NOT NULL ,
  note_class_concept_id 		INTEGER			NOT NULL ,
  note_title					VARCHAR(250)	NULL ,
  note_text						TEXT  			NULL ,
  encoding_concept_id			INTEGER			NOT NULL ,
  language_concept_id			INTEGER			NOT NULL ,
  provider_id					BIGINT			NULL ,
  visit_occurrence_id			BIGINT			NULL ,
  visit_detail_id       		BIGINT       	NULL ,
  note_source_value				VARCHAR(50)		NULL
)
;


if object_id('@cdm_schema.note_nlp', 'U')  is not null drop table @cdm_schema.note_nlp;
CREATE TABLE @cdm_schema.note_nlp
(
  note_nlp_id					BIGINT			NOT NULL ,
  note_id						BIGINT			NOT NULL ,
  section_concept_id			INTEGER			NOT NULL ,
  snippet						VARCHAR(250)	NULL ,
  "offset"					    VARCHAR(250)	NULL ,
  lexical_variant				VARCHAR(250)	NOT NULL ,
  note_nlp_concept_id			INTEGER			NOT NULL ,
  nlp_system					VARCHAR(250)	NULL ,
  nlp_date						DATE			NOT NULL ,
  nlp_datetime					TIMESTAMP		NULL ,
  term_exists					VARCHAR(1)		NULL ,
  term_temporal					VARCHAR(50)		NULL ,
  term_modifiers				VARCHAR(2000)	NULL ,
  note_nlp_source_concept_id  	INTEGER			NOT NULL
)
;

if object_id('@cdm_schema.observation', 'U')  is not null drop table @cdm_schema.observation;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.observation
(
  observation_id				INTEGER			NOT NULL ,
  person_id						INTEGER			NOT NULL ,
  observation_concept_id		INTEGER			NOT NULL ,
  observation_date				DATE			NOT NULL ,
  observation_datetime			TIMESTAMP		NULL ,
  observation_type_concept_id	INTEGER			NOT NULL ,
  value_as_number				NUMERIC			NULL ,
  value_as_string				VARCHAR(60)	    NULL ,
  value_as_concept_id			INTEGER			NULL ,
  qualifier_concept_id			INTEGER			NULL ,
  unit_concept_id				INTEGER			NULL ,
  provider_id					INTEGER			NULL ,
  visit_occurrence_id			INTEGER			NULL ,
  visit_detail_id               INTEGER         NULL ,
  observation_source_value		VARCHAR(50)	    NULL ,
  observation_source_concept_id	INTEGER			NULL ,
  unit_source_value				VARCHAR(50)	    NULL ,
  qualifier_source_value		VARCHAR(50)	    NULL
)
;


if object_id('@cdm_schema.survey_conduct', 'U')  is not null drop table @cdm_schema.survey_conduct;
--HINT DISTRIBUTE ON KEY(person_id)
CREATE TABLE @cdm_schema.survey_conduct 
(
  survey_conduct_id					BIGINT			NOT NULL ,
  person_id						    BIGINT			NOT NULL ,
  survey_concept_id			  		INTEGER			NOT NULL ,
  survey_start_date				    DATE			NULL ,
  survey_start_datetime				TIMESTAMP		NULL ,
  survey_end_date					DATE			NULL ,
  survey_end_datetime				TIMESTAMP		NOT NULL ,
  provider_id						BIGINT			NULL ,
  assisted_concept_id	  			INTEGER			NOT NULL ,
  respondent_type_concept_id		INTEGER			NOT NULL ,
  timing_concept_id					INTEGER			NOT NULL ,
  collection_method_concept_id		INTEGER			NOT NULL ,
  assisted_source_value		  		VARCHAR(50)		NULL ,
  respondent_type_source_value		VARCHAR(100)  	NULL ,
  timing_source_value				VARCHAR(100)	NULL ,
  collection_method_source_value	VARCHAR(100)	NULL ,
  survey_source_value				VARCHAR(100)	NULL ,
  survey_source_concept_id			INTEGER			NOT NULL ,
  survey_source_identifier			VARCHAR(100)	NULL ,
  validated_survey_concept_id		INTEGER			NOT NULL ,
  validated_survey_source_value		VARCHAR(100)	NULL ,
  survey_version_number				VARCHAR(20)		NULL ,
  visit_occurrence_id				BIGINT			NULL ,
  visit_detail_id					BIGINT			NULL ,
  response_visit_occurrence_id	BIGINT			NULL
)
;

if object_id('@cdm_schema.fact_relationship', 'U')  is not null drop table @cdm_schema.fact_relationship;
CREATE TABLE @cdm_schema.fact_relationship
(
  domain_concept_id_1			INTEGER			NOT NULL ,
  fact_id_1						    INTEGER			NOT NULL ,
  domain_concept_id_2			INTEGER			NOT NULL ,
  fact_id_2						    INTEGER			NOT NULL ,
  relationship_concept_id	INTEGER			NOT NULL
)
;



/************************

Standardized health system data

************************/

if object_id('@cdm_schema.location', 'U')  is not null drop table @cdm_schema.location;
CREATE TABLE @cdm_schema.location
(
  location_id			BIGINT			NOT NULL ,
  address_1				VARCHAR(50)		NULL ,
  address_2				VARCHAR(50)		NULL ,
  city					VARCHAR(50)		NULL ,
  state					VARCHAR(2)		NULL ,
  zip					VARCHAR(9)		NULL ,
  county				VARCHAR(20)		NULL ,
  country				VARCHAR(100)	NULL ,
  location_source_value VARCHAR(50)		NULL ,
  latitude				NUMERIC			NULL ,
  longitude				NUMERIC			NULL
)
;

if object_id('@cdm_schema.location_history', 'U')  is not null drop table @cdm_schema.location_history;
--HINT DISTRIBUTE ON RANDOM
CREATE TABLE @cdm_schema.location_history --Table added
(
  location_history_id           BIGINT      NOT NULL ,
  location_id			        BIGINT		NOT NULL ,
  relationship_type_concept_id	INTEGER		NOT NULL , 
  domain_id				        VARCHAR(50)	NOT NULL ,
  entity_id				        BIGINT		NOT NULL ,
  start_date			        DATE		NOT NULL ,
  end_date				        DATE		NULL
)
;


if object_id('@cdm_schema.care_site', 'U')  is not null drop table @cdm_schema.care_site;
CREATE TABLE @cdm_schema.care_site
(
  care_site_id					BIGINT			NOT NULL ,
  care_site_name				VARCHAR(255)	NULL ,
  place_of_service_concept_id	INTEGER			NOT NULL ,
  location_id					BIGINT			NULL ,
  care_site_source_value		VARCHAR(50)		NULL ,
  place_of_service_source_value	VARCHAR(50)		NULL
)
;

if object_id('@cdm_schema.provider', 'U')  is not null drop table @cdm_schema.provider;
CREATE TABLE @cdm_schema.provider
(
  provider_id					BIGINT			NOT NULL ,
  provider_name					VARCHAR(255)	NULL ,
  NPI							VARCHAR(20)		NULL ,
  DEA							VARCHAR(20)		NULL ,
  specialty_concept_id			INTEGER			NOT NULL ,
  care_site_id					BIGINT			NULL ,
  year_of_birth					INTEGER			NULL ,
  gender_concept_id				INTEGER			NOT NULL ,
  provider_source_value			VARCHAR(50)		NULL ,
  specialty_source_value		VARCHAR(50)		NULL ,
  specialty_source_concept_id	INTEGER			NULL ,
  gender_source_value			VARCHAR(50)		NULL ,
  gender_source_concept_id		INTEGER			NOT NULL
)
;


/************************

Standardized health economics

************************/

if object_id('@cdm_schema.payer_plan_period', 'U')  is not null drop table @cdm_schema.payer_plan_period;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.payer_plan_period
(
  payer_plan_period_id			BIGINT			NOT NULL ,
  person_id						BIGINT			NOT NULL ,
  contract_person_id            BIGINT        	NULL ,
  payer_plan_period_start_date  DATE			NOT NULL ,
  payer_plan_period_end_date	DATE			NOT NULL ,
  payer_concept_id              INTEGER       	NOT NULL ,
  plan_concept_id               INTEGER       	NOT NULL ,
  contract_concept_id           INTEGER       	NOT NULL ,
  sponsor_concept_id            INTEGER       	NOT NULL ,
  stop_reason_concept_id        INTEGER       	NOT NULL ,
  payer_source_value			VARCHAR(50)	  	NULL ,
  payer_source_concept_id       INTEGER       	NOT NULL ,
  plan_source_value				VARCHAR(50)	  	NULL ,
  plan_source_concept_id        INTEGER       	NOT NULL ,
  contract_source_value         VARCHAR(50)   	NULL ,
  contract_source_concept_id    INTEGER       	NOT NULL ,
  sponsor_source_value          VARCHAR(50)   	NULL ,
  sponsor_source_concept_id     INTEGER       	NOT NULL ,
  family_source_value			VARCHAR(50)	  	NULL ,
  stop_reason_source_value      VARCHAR(50)   	NULL ,
  stop_reason_source_concept_id INTEGER       	NOT NULL
)
;

if object_id('@cdm_schema.cost', 'U')  is not null drop table @cdm_schema.cost;
CREATE TABLE @cdm_schema.cost
(
  cost_id						BIGINT		NOT NULL ,
  person_id						BIGINT		NOT NULL,
  cost_event_id					BIGINT      NOT NULL ,
  cost_event_field_concept_id	INTEGER		NOT NULL , 
  cost_concept_id				INTEGER		NOT NULL ,
  cost_type_concept_id		  	INTEGER     NOT NULL ,
  currency_concept_id			INTEGER		NOT NULL ,
  cost							NUMERIC		NULL ,
  incurred_date					DATE		NOT NULL ,
  billed_date					DATE		NULL ,
  paid_date						DATE		NULL ,
  revenue_code_concept_id		INTEGER		NOT NULL ,
  drg_concept_id			    INTEGER		NOT NULL ,
  cost_source_value				VARCHAR(50)	NULL ,
  cost_source_concept_id	  	INTEGER		NOT NULL ,
  revenue_code_source_value 	VARCHAR(50) NULL ,
  drg_source_value			    VARCHAR(3)	NULL ,
  payer_plan_period_id			BIGINT		NULL
)
;


/************************

Standardized derived elements

************************/

if object_id('@cdm_schema.drug_era', 'U')  is not null drop table @cdm_schema.drug_era;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.drug_era
(
  drug_era_id					INTEGER			NOT NULL ,
  person_id						INTEGER			NOT NULL ,
  drug_concept_id			INTEGER			NOT NULL ,
  drug_era_start_date	DATE			  NOT NULL ,
  drug_era_end_date		DATE			  NOT NULL ,
  drug_exposure_count	INTEGER			NULL ,
  gap_days						INTEGER			NULL
)
;

if object_id('@cdm_schema.dose_era', 'U')  is not null drop table @cdm_schema.dose_era;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.dose_era
(
  dose_era_id					  INTEGER			NOT NULL ,
  person_id						  INTEGER			NOT NULL ,
  drug_concept_id				INTEGER			NOT NULL ,
  unit_concept_id				INTEGER			NOT NULL ,
  dose_value						NUMERIC			  NOT NULL ,
  dose_era_start_date		DATE			  NOT NULL ,
  dose_era_end_date	    DATE			  NOT NULL
)
;

if object_id('@cdm_schema.condition_era', 'U')  is not null drop table @cdm_schema.condition_era;
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE @cdm_schema.condition_era
(
  condition_era_id				    INTEGER			NOT NULL ,
  person_id						        INTEGER			NOT NULL ,
  condition_concept_id			  INTEGER			NOT NULL ,
  condition_era_start_date		DATE			  NOT NULL ,
  condition_era_end_date			DATE			  NOT NULL ,
  condition_occurrence_count	INTEGER			NULL
)
;
