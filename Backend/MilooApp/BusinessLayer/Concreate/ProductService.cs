using AutoMapper;
using BusinessLayer.Abstract;
using BusinessLayer.Dtos.ProductDtos;
using BusinessLayer.Exceptions;
using BusinessLayer.Extensions;
using BusinessLayer.Helpers;
using BusinessLayer.Helpers.FileHelper;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace BusinessLayer.Concreate
{
    public class ProductService : BaseService, IProductService
    {
        private readonly IProductRepository _productRepository;
        private readonly IUserRepository _userRepository;
        private readonly IValidator<CreateProductRequest> _createValidator;
        private readonly IValidator<UpdateProductDto> _updateValidator;
        private readonly IFileHelper _fileHelper;
        public ProductService(IMapper mapper, IProductRepository listingRepository, IValidator<CreateProductRequest> listingDtoValidator, IFileHelper fileHelper, IValidator<UpdateProductDto> updateValidator, IUserRepository userRepository) : base(mapper)
        {
            _productRepository = listingRepository;
            _createValidator = listingDtoValidator;
            _fileHelper = fileHelper;
            _updateValidator = updateValidator;
            _userRepository = userRepository;
        }

        public async Task<BaseResponse> AddAsync(CreateProductRequest createListingDto)
        {
            // Validate the request data
            await _createValidator.ValidateAndThrowAsync(createListingDto);

            Console.WriteLine("Ürün fiyat :Ç  " + createListingDto.Price);
            // Save images first
            List<string> imagePaths = await _fileHelper.SaveUserProductsAsync(createListingDto.Images, createListingDto.PublisherId);

            // Create the Product entity
            Product mappedListing = _mapper.Map<Product>(createListingDto);

            // Add the image paths to the Product entity
            mappedListing.Images = imagePaths.Select(x => new ProductImages { ImagePath = x }).ToList();

            // Save the Product entity to the database
            bool result = await _productRepository.AddAsync(mappedListing);

            // Return response
            return new BaseResponse
            {
                Success = result,
                Message = result ? "Listing added successfully" : "Listing could not be added"
            };
        }
        public async Task<BaseResponse> DeleteAsync(int id)
        {
            bool result = await _productRepository.DeleteAsync(id);
            return new()
            {
                Success = result,
                Message = result ? "Listing deleted successfully" : "Listing could not be deleted"
            };
        }
        public async Task<BaseResponse> GetByIdAsync(int id)
        {
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            var listing = await _productRepository.AsQueryable()
                .Include(x => x.Images)
                .Where(x => x.Id == id)
                .Select(x => new
                {
                    x.Id,
                    x.Title,
                    x.Description,
                    isFavorite = true,
                    x.Price,
                    createrFullName = $"{x.Publisher.FirstName} {x.Publisher.LastName}",
                    createdBy = x.Publisher.UserName,
                    x.Views,
                    Images = x.Images.Select(img => $"{baseUrl}/{img.ImagePath}").ToList()
                })
                .FirstOrDefaultAsync() ?? throw new DbValidationException("Listing Not found");

            return new()
            {
                Success = true,
                Data = listing
            };
        }
        public async Task<BaseResponse> GetAllProducts(BaseProductRequestDto request)
        {
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            var query = _productRepository.AsQueryable()
                                   .Include(x => x.SubCategory)
                                   .ThenInclude(sc => sc.Category)  // Kategori bilgisi için ilişkiyi ekleyin
                                   .AsNoTracking();

            // Eğer arama varsa, ürünleri başlıkla filtreleyin
            if (!string.IsNullOrEmpty(request.Search))
                query = query.Where(x => x.Title.Contains(request.Search, StringComparison.OrdinalIgnoreCase));

            // Kategori filtresi
            if (request.CategoryId != -1)
                query = query.Where(x => x.SubCategory.Category.Id == request.CategoryId); // Kategoriye göre filtrele

            // Alt kategori filtresi
            if (request.SubCategoryId != -1)
                query = query.Where(x => x.SubCategoryId == request.SubCategoryId); // Alt kategoriye göre filtrele

            // Üniversite filtresi
            query = query.Where(x => x.Publisher.UniversityId == request.UniversityId);

            // Sıralama kriteri
            switch (request.OrderBy)
            {
                case "price-low":
                    query = query.OrderBy(x => x.Price);
                    break;
                case "price-high":
                    query = query.OrderByDescending(x => x.Price);
                    break;
                case "popular":
                    query = query.OrderByDescending(x => x.Views);
                    break;
                case "newest":
                    query = query.OrderByDescending(x => x.CreatedAt);
                    break;
                default:
                    query = query.OrderByDescending(x => x.Views);
                    break;
            }

            // Seçilen sayfalama kriterine göre sonuçları al
            var result = await query.Select(x => new
            {
                x.Id,
                x.Title,
                x.SubCategory.Category.Name,
                image = $"{baseUrl}/{x.Images.FirstOrDefault().ImagePath}", // Null-safe erişim
                isFavorite = true,
                x.Price
            }).GetPageAsync(request.PageNumber, request.PageSize) ?? throw new DbValidationException("Listings Not found");

            return new BaseResponse
            {
                Data = result,
                Success = true
            };
        }
        public async Task<BaseResponse> GetPopularProducts(int top, int universityId, int userId)
        {
            string ipAddress = IPHelper.GetIpAdress(); // IP adresi alınır
            string baseUrl = $"http://{ipAddress}:5105"; // Base URL oluşturulur

            // Popüler ürünleri al ve favori durumunu kontrol et
            var popularProducts = await _productRepository.AsQueryable()
                .AsNoTracking()
                .Where(p => p.Publisher.UniversityId == universityId) // Üniversiteye göre filtrele
                .OrderByDescending(p => p.Views) // Görüntülenme sayısına göre sırala
                .Take(top) // En popüler 'top' ürünü al
                .Select(p => new
                {
                    p.Id,
                    p.Title,
                    p.Price,
                    image = $"{baseUrl}/{p.Images.FirstOrDefault().ImagePath}", // İlk görselin yolunu oluştur
                    isFavorite = p.UserFavoriteProducts.Any(uf => uf.UserId == userId && uf.Status) // Kullanıcının favorisi mi?
                })
                .ToListAsync();

            return new BaseResponse
            {
                Data = popularProducts,
                Success = true
            };
        }
        public async Task<BaseResponse> UpdateAsync(UpdateProductDto request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            Product p = await _productRepository.GetByIdAsync(request.Id) ?? throw new DbValidationException("Product not found");
            if (p == null) {
                throw new DbValidationException("Product not found");
            }
            p.Title = request.Title;
            p.Price = request.Price;
            bool result = await _productRepository.UpdateAsync(p);


            return new()
            {
                Success = result,
                Message = result ? "Listing updated successfully" : "Listing could not be updated"
            };
        }
        public async Task<BaseResponse> AddFavoriteProduct(MakeFavoriteProductDto request)
        {
            bool result = await _productRepository.AddOrDeleteFavoriteProduct(request.UserId, request.ProductId);
            return new BaseResponse
            {
                Success = result,
                Message = result ? "Product added to favorites" : "Product could not be added to favorites"
            };
        }
        public async Task<BaseResponse> IncreaseProductView(IncreaseProductView request)
        {
            var result = await _productRepository.AsQueryable()
                 .Where(x => x.Id == request.ProductId)
                 .ExecuteUpdateAsync(x => x.SetProperty(x => x.Views, x => x.Views + 1));

            return new()
            {
                Success = result > 0,
                Message = result > 0 ? "Product view increased" : "Product view could not be increased"
            };
        }
        public async Task<BaseResponse> GetFavoriteProducts(FavoriProductRequest request)
        {
            string ipAddress = IPHelper.GetIpAdress(); // IP adresi alınır
            string baseUrl = $"http://{ipAddress}:5105"; // Base URL oluşturulur

            // Favori ürünleri sorgula
            var favoriteProducts = await _productRepository.AsQueryable()
                .Where(x => x.UserFavoriteProducts.Any(uf => uf.UserId == request.UserId && uf.Status))
                .Select(x => new
                {
                    x.Id,
                    x.Title,
                    x.Price,
                    isFavorite = true,
                    image = $"{baseUrl}/{x.Images.FirstOrDefault().ImagePath}"
                })
                .GetPageAsync(request.PageNumber, request.PageSize);

            return new BaseResponse
            {
                Data = favoriteProducts,
                Success = true
            };
        }
        public async Task<BaseResponse> GetUserProducts(UserProductRequest request)
        {
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            var query = _productRepository.AsQueryable()
                .Include(x => x.Images)
                .AsNoTracking();

            // Eğer arama varsa, ürünleri başlıkla filtreleyin
            if (!string.IsNullOrEmpty(request.Search))
                query = query.Where(x => x.Title.ToLower().Contains(request.Search.ToLower()));


            // Kullanıcının ürünlerini al
            query = query.Where(x => x.PublisherId == request.UserId);

            // Sıralama kriteri
            query = query.OrderByDescending(x => x.CreatedAt);
            query = query.OrderByDescending(x => x.Views);

            // Seçilen sayfalama kriterine göre sonuçları al
            var result = await query.Select(x => new
            {
                x.Id,
                x.Title,
                x.Price,
                x.isSold,
                image = $"{baseUrl}/{x.Images.FirstOrDefault().ImagePath}",
            }).GetPageAsync(request.PageNumber, request.PageSize) ?? throw new DbValidationException("Listings Not found");


            return new BaseResponse
            {
                Data = result,
                Success = true
            };
        }

        public async Task<BaseResponse> MarkSold(int id)
        {
            int result = await _productRepository.AsQueryable()
                  .Where(x => x.Id == id)
                  .ExecuteUpdateAsync(x => x.SetProperty(x => x.isSold, true));

            if (result == 0)
                throw new DbValidationException("Product not found");

            return new BaseResponse
            {
                Success = true,
                Message = "Product marked as sold"
            };
        }
    }
}
