using AutoMapper;
using BusinessLayer.Dtos.CategoryDtos;
using BusinessLayer.Dtos.CollageDtos;
using BusinessLayer.Dtos.ProductDtos;
using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<CreateCategoryDto, Category>();
            CreateMap<UpdateCategoryDto, Category>();

            CreateMap<CreateCollageDto, University>();
            CreateMap<UpdateCollageDto, University>();


            CreateMap<CreateProductRequest, Product>()
             .ForMember(dest => dest.Images, opt => opt.Ignore()); // Images özelliği özel bir işleme ihtiyaç duyabilir.

            CreateMap<UpdateProductDto, Product>();

        }
    }
}
