
using BusinessLayer.Abstract;
using BusinessLayer.Dtos.CategoryDtos;
using BusinessLayer.Dtos.CollageDtos;
using BusinessLayer.Parameters;
using EntityLayer.Entites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class CategoryController(ICategoryService categoryService) : ControllerBase
    {
        private readonly ICategoryService _categoryService = categoryService;


        [HttpGet("getall")]
        public async Task<IActionResult> GetResult([FromQuery] BaseRequest request)
        {
            BaseResponse response = await _categoryService.GetCategories(request);
            return Ok(response.Data);
        }

        [HttpGet("getallwithsubcategory")]
        public async Task<IActionResult> GetResultWithSubCategory([FromQuery] BaseCategoryRequest request)
        {
            BaseResponse response = await _categoryService.GetCategoryWithSubCategory(request);
            return Ok(response.Data);
        }

        [HttpGet("id/{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> GetById(int id)
        {
            BaseResponse response = await _categoryService.GetByIdAsync(id);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return NotFound(response.Message);
        }

        [HttpGet("name/{name}")]
        [Authorize(Roles = "Admin,User")]
        public async Task<IActionResult> GetByName(string name)
        {
            BaseResponse response = await _categoryService.GetByNameAsync(name);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return NotFound(response.Message);
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create([FromBody] CreateCategoryDto category)
        {
            BaseResponse response = await _categoryService.AddAsync(category);
            if (response.Success)
            {
                return CreatedAtAction(nameof(Create), response.Data);
            }
            return StatusCode(400, response.Message);
        }

        [HttpPut("update")]
        public async Task<IActionResult> Update([FromBody] UpdateCategoryDto category)
        {
            BaseResponse response = await _categoryService.UpdateAsync(category);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return StatusCode(400, response.Message);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            BaseResponse response = await _categoryService.DeleteAsync(id);
            if (response.Success)
            {
                return Ok(response.Message);
            }
            return StatusCode(400, response.Message);
        }
    }
}
