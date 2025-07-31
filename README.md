# SQL Projects: Real-World Data Cleaning & Exploration

This repository contains SQL scripts for exploring, cleaning, and analyzing various datasets.
The projects focus on data cleaning, aggregation, and exploration using SQL functions like joins, CTEs (Common Table Expressions), window functions, and data transformations.

## Projects Overview

### [1. COVID Data Cleaning & Exploration](./COVID%20Data%20Cleaning%20%26%20Exploration)
   This project involves cleaning and exploring COVID-related data from [Our World in Data](https://ourworldindata.org/coronavirus).
   The SQL script includes data aggregation, exploration, and cleaning processes.

   **Files**:
   - `covid_data.csv`: Raw dataset for analysis.
   - `CovidDeaths.xlsx`: Dataset of COVID death records.
   - `CovidVaccinations.xlsx`: Dataset of COVID vaccination records.
   - `SQL - COVID Data Exploration.sql`: SQL script for cleaning and exploring COVID-related data using various SQL functions.

   **Skills Used**:
   - SQL (MySQL Workbench)
   - Data cleaning and aggregation
   - Joins, CTEs, window functions, aggregate functions, handling missing data

   **How to Use**:
   1. Download the raw data from the **/data** folder.
   2. Open the `SQL - COVID Data Exploration.sql` script in your preferred SQL editor (e.g., SSMS or MySQL Workbench).
   3. Execute the queries to clean and explore the data.
   4. Review the results for insights on trends in COVID cases, deaths, and vaccinations.

---

### [2. IMDB Top 1000 Data Exploration](./IMDB%20Data%20Cleaning%20and%20Exploration)
   This project explores and analyzes the IMDB Top 1000 movie dataset. The script includes SQL queries for sorting, filtering, and
   aggregating data to explore movie trends, ratings, and genres.

   **Files**:
   - `imdb_top_1000.csv`: Raw dataset for analysis.
   - `SQL - imdb_cleaning_script.sql`: SQL script to clean the IMDB Top 1000 dataset.
   - `SQL - imdb_data_exploration_script.sql`: Exploring the IMDB dataset.

   **Skills Used**:
   - SQL (SQL Server Management Studio (SSMS))
   - Data exploration, filtering, and aggregation
   - Using SQL functions for sorting, grouping, and analyzing data

   **How to Use**:
   1. Download the raw data from the **/data** folder.
   2. Open `SQL - IMDB Data Exploration.sql` in **SQL Server Management Studio (SSMS)**.
   3. Execute the queries to explore the dataset, clean the data, and extract insights on movie trends.
   4. Analyze movie ratings, genres, and top-rated films.

---

### [3. Nashville Housing Data Cleaning](./Nashville%20Housing%20Data%20Cleaning)
   This project cleans a dataset of Nashville housing data, focusing on transforming and preparing it for further analysis.

   **Files**:
   - `NashvilleHousing - Data Cleaning.xlsx`: Raw dataset of Nashville housing data.
   - `SQL - NashvilleHousing Data Cleaning.sql`: SQL script for cleaning the Nashville housing data, including handling missing values,
     correcting data types, and aggregating data.

   **Skills Used**:
   - SQL (MySQL Workbench)
   - Data cleaning and transformation
   - Using SQL functions like `CASE`, `COALESCE`, and `ISNULL` for handling missing data

   **How to Use**:
   1. Download the raw data from the **/data** folder.
   2. Open `SQL - NashvilleHousing Data Cleaning.sql` in your SQL editor (SSMS or MySQL Workbench).
   3. Execute the queries to clean the data.
   4. Review the cleaned dataset for analysis on housing prices and trends in Nashville.

---

## Tools Used
- **SQL (MySQL/SQL Server)**
- **SQL Server Management Studio (SSMS)** or **MySQL Workbench**

## License
This project is licensed under the MIT License.
