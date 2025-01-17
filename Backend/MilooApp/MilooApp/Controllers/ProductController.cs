using BusinessLayer.Abstract;
using BusinessLayer.Dtos.ProductDtos;
using BusinessLayer.Parameters;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ProductController : ControllerBase
    {
        private readonly IProductService _productService;

        public ProductController(IProductService listingService)
        {
            _productService = listingService;
        }

        [HttpGet("getall")]
        public async Task<IActionResult> GetResult([FromQuery] BaseProductRequestDto request)
        {
            BaseResponse response = await _productService.GetAllProducts(request);
            if (response.Success)
                return Ok(response.Data);
            return BadRequest();
        }
        [HttpGet("user-products")]
        [Authorize(Roles ="Seller,Admin")]
        public async Task<IActionResult> GetUserProducts([FromQuery] UserProductRequest request)
        {
            BaseResponse response = await _productService.GetUserProducts(request);
            if (response.Success)
                return Ok(response.Data);
            return BadRequest();
        }


        [HttpGet("favorite-products")]
        public async Task<IActionResult> GetFavoriteProducts([FromQuery] FavoriProductRequest request)
        {
            BaseResponse response = await _productService.GetFavoriteProducts(request);
            if (response.Success)
                return Ok(response.Data);
            return BadRequest();
        }


        [HttpGet("popular-products")]
        public async Task<IActionResult> GetPopularProducts([FromQuery] int top)
        {
            var  userIdClaim = HttpContext.User.Claims.FirstOrDefault(c => c.Type == "userId");
            if(userIdClaim == null)
                return BadRequest("User not found");
            int userId = int.Parse(userIdClaim.Value);

            BaseResponse response = await _productService.GetPopularProducts(top=5, userId: userId);
            if (response.Success)
                return Ok(response.Data);
            return BadRequest();
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            BaseResponse response = await _productService.GetByIdAsync(id);
            if (response.Success)
                return Ok(response.Data);
            return BadRequest();
        }

        [HttpPost("create")]
        [Authorize(Roles = "Seller")]
        public async Task<IActionResult> AddProduct([FromForm] CreateProductRequest createListingDto)
        {
            BaseResponse response = await _productService.AddAsync(createListingDto);

            if (response.Success)
            {
                return Ok(response.Message);
            }
            return BadRequest(response.Message);
        }


        [HttpPost("increase-view")]
        public async Task<IActionResult> IncreaseProductView([FromBody] IncreaseProductView requeset)
        {
            BaseResponse response = await _productService.IncreaseProductView(requeset);
            if (response.Success)
                return Ok(response.Message);
            return BadRequest(response.Message);
        }
        [HttpPost("make-favorite")]
        public async Task<IActionResult> AddFavoriteProduct([FromBody] MakeFavoriteProductDto request)
        {
            BaseResponse response = await _productService.AddFavoriteProduct(request);
            if (response.Success)
                return Ok(response.Message);
            return BadRequest(response.Message);
        }

     
        [HttpDelete("delete/{id}")]
        [Authorize(Roles = "Seller")]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            BaseResponse response = await _productService.DeleteAsync(id);
            if (response.Success)
            {
                return Ok();
            }
            return BadRequest();
        }



        [HttpPut("update")]
        [Authorize(Roles = "Seller")]
        public async Task<IActionResult> UpdateProduct([FromBody] UpdateProductDto updateProductRequest)
        {
            BaseResponse response = await _productService.UpdateAsync(updateProductRequest);
            if (response.Success)
            {
                return Ok(response.Message);
            }
            return BadRequest(response.Message);
        }

        [HttpPut("mark-sold/{id}")]
        [Authorize(Roles = "Seller")]
        public async Task<IActionResult> MarkSold(int id)
        {
            BaseResponse response = await _productService.MarkSold(id);
            if (response.Success)
            {
                return Ok(response.Message);
            }
            return BadRequest(response.Message);
        }
    }
}
