using AutoMapper;
using BusinessLayer.Abstract;
using BusinessLayer.Dtos.RoleDtos;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Concreate
{
    public class RoleService(IRoleRepository roleRepository, IMapper mapper, IValidator<UpdateRoleDto> updateValidator, IValidator<CreateRoleDto> createValidator) : BaseService(mapper), IRoleService
    {
        private readonly IValidator<CreateRoleDto> _createValidator = createValidator;
        private readonly IValidator<UpdateRoleDto> _updateValidator = updateValidator;
        private readonly IRoleRepository _roleRepository = roleRepository;
        public async Task<bool> AddRoleAsnyc(CreateRoleDto role)
        {
            await _createValidator.ValidateAndThrowAsync(role);
            Role createdRole = _mapper.Map<Role>(role);
            return await _roleRepository.AddAsync(createdRole);
        }

        public async Task<bool> DeleteRoleAsync(int id)
        {
            return await _roleRepository.DeleteAsync(id);
        }

        public async Task<Role> GetRoleByIdAsync(int id)
        {
            return await _roleRepository.GetByIdAsync(id);
        }

        public async Task<List<Role>> GetRolesAsync()
        {
            return await _roleRepository.GetAllAsync();
        }

        public async Task<bool> UpdateRoleAsync(UpdateRoleDto role)
        {
            _updateValidator.ValidateAndThrow(role);
            Role updatedRole = _mapper.Map<Role>(role);
            return await _roleRepository.UpdateAsync(updatedRole);
        }
    }
}
