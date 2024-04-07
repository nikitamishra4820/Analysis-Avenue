/*
Cleaning Data in SQL Queries
*/


SELECT * FROM Portfolio_Project..NashvilleHousing

-- Standardize Date Format

SELECT SaleDateConverted FROM Portfolio_Project..NashvilleHousing

ALTER Table NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT * FROM NashvilleHousing ORDER BY ParcelID ;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project..NashvilleHousing a
JOIN Portfolio_Project..NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project..NashvilleHousing a
JOIN Portfolio_Project..NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is NULL;



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress FROM Portfolio_Project..NashvilleHousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),(LEN(PropertyAddress))) AS Address
FROM Portfolio_Project..NashvilleHousing

ALTER Table portfolio_Project..NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

UPDATE portfolio_Project..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER Table portfolio_Project..NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

UPDATE portfolio_Project..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),(LEN(PropertyAddress)))

Select *
From Portfolio_Project.dbo.NashvilleHousing

--For OwnerAddress

Select OwnerAddress from Portfolio_Project..NashvilleHousing

Select PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)

from Portfolio_Project..NashvilleHousing

Alter Table portfolio_Project..NashvilleHousing
add OwnerSplitAddress NVARCHAR(255)

Update Portfolio_Project..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table portfolio_Project..NashvilleHousing
add OwnerSplitCity NVARCHAR(255)

Update Portfolio_Project..NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table portfolio_Project..NashvilleHousing
add OwnerSplitState NVARCHAR(255)

Update Portfolio_Project..NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select * from Portfolio_Project..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant),count(SoldAsVacant)
from Portfolio_Project..NashvilleHousing
group by SoldAsVacant;

Select soldAsVacant,
	CASE when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		END
from Portfolio_Project..NashvilleHousing

update Portfolio_Project..NashvilleHousing
 SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
					when SoldAsVacant = 'N' then 'No'
					Else SoldAsVacant
					END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY
                UniqueID
        ) AS row_num
    FROM Portfolio_Project.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Query to delete
DELETE 
From RowNumCTE
Where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate, OwnerSpiltAddress, OwnerSpiltCity















