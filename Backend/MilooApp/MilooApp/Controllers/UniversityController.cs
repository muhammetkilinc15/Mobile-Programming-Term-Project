using BusinessLayer.Abstract;
using BusinessLayer.Concreate;
using BusinessLayer.Dtos.CategoryDtos;
using BusinessLayer.Dtos.CollageDtos;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UniversityController : ControllerBase
    {
        private readonly ICollageService _service;

        public UniversityController(ICollageService service)
        {
            _service = service;
        }

        [HttpGet("getall")]
        public async Task<IActionResult> GetResult([FromQuery] BaseRequest request)
        {
            BaseResponse response = await _service.GetPagedResponseAsync(request);
            return Ok(response.Data);
        }

        [HttpGet("id/{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            BaseResponse response = await _service.GetByIdAsync(id);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return NotFound(response.Message);
        }

        [HttpGet("name/{name}")]
        public async Task<IActionResult> GetByName(string name)
        {
            BaseResponse response = await _service.GetByNameAsync(name);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return NotFound(response.Message);
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create([FromBody] CreateCollageDto category)
        {
            BaseResponse response = await _service.AddAsync(category);
            if (response.Success)
            {
                return CreatedAtAction(nameof(Create), response.Data);
            }
            return StatusCode(400, response.Message);
        }

        [HttpPut("update")]
        public async Task<IActionResult> Update([FromBody] UpdateCollageDto category)
        {
            BaseResponse response = await _service.UpdateAsync(category);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return StatusCode(400, response.Message);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            BaseResponse response = await _service.DeleteAsync(id);
            if (response.Success)
            {
                return Ok(response.Message);
            }
            return StatusCode(400, response.Message);
        }
    }
}
