using AutoMapper;
using DataAccessLayer.Abstract;
using EntityLayer.Entites.Base;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Concreate
{
    public class BaseService(IMapper mapper)
    {
        protected readonly IMapper _mapper = mapper;
    }

}
