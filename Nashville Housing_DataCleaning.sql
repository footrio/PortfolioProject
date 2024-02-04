Select *
From PortfolioProject.dbo.NashvilleHousing

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null




Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySpritAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySpritAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvilleHousing
Add PropertySpritCity Nvarchar(255);

Update NashvilleHousing
SET PropertySpritCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select*
From PortfolioProject.dbo.NashvilleHousing






Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing
Where OwnerAddress is not null


Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.NashvilleHousing
Where OwnerAddress is not null




ALTER TABLE NashvilleHousing
Add OwnerSpritAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSpritAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerSpritCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSpritCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSpritState Nvarchar(255);

Update NashvilleHousing
SET OwnerSpritState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)



select *
from PortfolioProject..NashvilleHousing
where OwnerAddress is not null




Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,  CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END




WITH RowNumCTE AS (
Select *
,    ROW_NUMBER() OVER (
     PARTITION BY ParcelID, 
	 PropertyAddress, 
	 SalePrice, 
	 SaleDate, 
	 LegalReference
	 ORDER BY UniqueID) row_num
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress




Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate