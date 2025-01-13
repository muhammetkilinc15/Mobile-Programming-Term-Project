using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Abstract
{
    public interface IGenericRepository<TEntity> where TEntity : BaseEntity
    {
        Task<bool> AddAsync(TEntity entity);
        Task<bool> AddAsync(IEnumerable<TEntity> entities);
        Task<bool> UpdateAsync(TEntity entity);
        Task<bool> DeleteAsync(TEntity entity);
        Task<bool> DeleteAsync(int id);
        Task<bool> DeleteRangeAsync(Expression<Func<TEntity, bool>> predicate);

        IQueryable<TEntity> AsQueryable();

        Task<List<TEntity>> GetAllAsync(bool noTracking = true);

        Task<List<TEntity>> GetList(Expression<Func<TEntity, bool>> predicate, bool noTracking = true, IOrderedQueryable<TEntity>? orderBy = null, params Expression<Func<TEntity, object>>[] includes);
        Task<TEntity> GetByIdAsync(int id, bool noTracking = true, params Expression<Func<TEntity, object>>[] includes);

        Task<TEntity> GetSingleAsync(Expression<Func<TEntity, bool>> predicate, bool noTracking = true, params Expression<Func<TEntity, object>>[] includes);

        IQueryable<TEntity> Get(Expression<Func<TEntity, bool>> predicate, bool noTracking = true, params Expression<Func<TEntity, object>>[] includes);
 
    }
}
