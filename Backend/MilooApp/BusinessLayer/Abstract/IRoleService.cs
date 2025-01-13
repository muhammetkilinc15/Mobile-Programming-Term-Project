using BusinessLayer.Dtos.RoleDtos;
using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract
{
    public interface IRoleService
    {
        Task<List<Role>> GetRolesAsync();
        Task<Role> GetRoleByIdAsync(int id);
        Task<bool> AddRoleAsnyc(CreateRoleDto role);
        Task<bool> UpdateRoleAsync(UpdateRoleDto role);
        Task<bool> DeleteRoleAsync(int id);
    }
}
