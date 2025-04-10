/*
	Cleaning data in SQL Queries
*/

-- Display the entire NashvilleHousing dataset
SELECT *
FROM PortfolioProject..NashvilleHousing

-- Standardize the Date Format: Converting SaleDate to a proper Date format
SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM PortfolioProject..NashvilleHousing

-- Attempt to update SaleDate to ensure it's in the correct format
UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)

-- If the update doesn't work as expected, add a new column for the converted date
ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

-- Populate missing Property Address Data by joining the table with itself
SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Update the PropertyAddress where it's NULL using the fallback value
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Breaking out the Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM NashvilleHousing

-- Extracting Address and City from the PropertyAddress
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT OwnerAddress 
FROM NashvilleHousing

-- Extract components of OwnerAddress using PARSENAME and REPLACE
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Change values in "Sold as Vacant" field from Y/N to Yes/No
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- Checking the conversion of SoldAsVacant
SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END
FROM NashvilleHousing

-- Update SoldAsVacant to standardize the values
UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END
FROM NashvilleHousing

-- Remove duplicate entries in the dataset based on key columns
;WITH RowNumCTE AS (
	SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY ParcelID,
						 PropertyAddress,
						 SaleDate,
						 LegalReference
			ORDER BY UniqueID
		) AS row_num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1  -- Deletes all duplicates except the first occurrence

-- Delete unused columns to clean up the dataset
SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,
           TaxDistrict,
           PropertyAddress,
           SaleDate;


