--look at the data 
Select *
From PortfolioProject2.dbo.nashvillehousing

-- Standardize Date Format
Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject2.dbo.nashvillehousing


Update PortfolioProject2.dbo.nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select *
From PortfolioProject2.dbo.nashvillehousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2.dbo.nashvillehousing a
JOIN PortfolioProject2.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2.dbo.nashvillehousing a
JOIN PortfolioProject2.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select *
From PortfolioProject2.dbo.nashvillehousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Addresstown

From PortfolioProject2.dbo.nashvillehousing

ALTER TABLE PortfolioProject2.dbo.nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject2.dbo.nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject2.dbo.nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject2.dbo.nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


-- Breaking out Address into Individual Columns 

Select *
From PortfolioProject2.dbo.nashvillehousing

Select OwnerAddress
From PortfolioProject2.dbo.nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject2.dbo.nashvillehousing


ALTER TABLE PortfolioProject2.dbo.nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject2.dbo.nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject2.dbo.nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject2.dbo.nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject2.dbo.nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject2.dbo.nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject2.dbo.nashvillehousing

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2.dbo.nashvillehousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject2.dbo.nashvillehousing


Update PortfolioProject2.dbo.nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject2.dbo.nashvillehousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject2.dbo.NashvilleHousing


-- Delete Unused Columns



Select *
From PortfolioProject2.dbo.nashvillehousing


ALTER TABLE PortfolioProject2.dbo.nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate