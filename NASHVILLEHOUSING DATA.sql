---- Data cleaning in SQL

--- Now we are gpoing to have another look at the data we are going to be cleaning
SELECT *
FROM PortfolioProject..NashvilleHousing

--- looking at the sale date/standardizing it

select saleDate
from PortfolioProject..NashvilleHousing


select saleDate, convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
SET SaleDate = convert(Date, SaleDate)

Alter table NashvilleHousing
ADD SaleDate_new Date;

update NashvilleHousing
Set SaleDate_new = convert(Date, SaleDate)


--- taking a look at the converted date

select saleDate_new, convert(Date, Saledate)
from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------

----- Looking at the Property Address data

Select *
from PortfolioProject..NashvilleHousing
---where PropertyAddress is null
order by 1, 2

----- cleaning up duplicates/adding a join

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


--- Using substrings to Separate address into individual columns (Cty, state and address)

select PropertyAddress
from PortfolioProject..NashvilleHousing
---where PropertyAddress is null
--- order by ParceID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing



Alter table PortfolioProject..NashvilleHousing
ADD PropertyAddressSplit Nvarchar(225);

update PortfolioProject..NashvilleHousing
Set PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter table PortfolioProject..NashvilleHousing
ADD PropertyAddressCitySplit nvarchar(225);

update PortfolioProject..NashvilleHousing
Set PropertyAddressCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

---Taking a look of what we have done so far

select *
from PortfolioProject..NashvilleHousing


--- deleted a column that was no longer needed

alter table PortfolioProject..NashvilleHousing
drop column PropertySplitAddress

-------------------------------------------------------------------------------------------
--- Using PARSENAME to sort owners address and having it separated

select
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
from PortfolioProject..NashvilleHousing



Alter table PortfolioProject..NashvilleHousing
ADD OwnerAddressSplit Nvarchar(225);

update PortfolioProject..NashvilleHousing
Set OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)


Alter table PortfolioProject..NashvilleHousing
ADD OwnerAddressCitySplit nvarchar(225);

update PortfolioProject..NashvilleHousing
Set OwnerAddressCitySplit = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)


Alter table PortfolioProject..NashvilleHousing
ADD OwnerAddressStateSplit nvarchar(225);

update PortfolioProject..NashvilleHousing
Set OwnerAddressStateSplit = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)


---- looking at what we have done

select *
from PortfolioProject..NashvilleHousing

---------------------------------------------------------
---want to take a look at the SoldAsVacant column and reorganize it using the case statement

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
end
from PortfolioProject..NashvilleHousing


update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
end



----------------------------------------------
---removing duplicate---

WITH RowNumCTE AS(
select *,
row_number()over (
partition by ParcelID, 
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by
			 uniqueID
			 ) row_num

from portfolioproject..nashvillehousing
---order by ParcelID	
)
select *
FROM RowNumCTE 
where row_num > 1
order by propertyaddress



from PortfolioProject..NashvilleHousing


------------------------------------------------------
--- getting rid of more unused columns

select *
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject..NashvilleHousing
Drop column SaleDate
