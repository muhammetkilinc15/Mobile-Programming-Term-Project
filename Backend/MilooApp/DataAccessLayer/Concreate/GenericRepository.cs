using DataAccessLayer.Abstract;
using DataAccessLayer.Context;
using EntityLayer.Entites.Base;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Concreate
{
    public class GenericRepository<TEntity>(ApplicationDbContext context) : IGenericRepository<TEntity> where TEntity : BaseEntity
    {
        protected ApplicationDbContext _context = context;

        protected DbSet<TEntity> Entity => _context.Set<TEntity>();

        public async Task<bool> AddAsync(TEntity entity)
        {
            await Entity.AddAsync(entity);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> AddAsync(IEnumerable<TEntity> entities)
        {
            await Entity.AddRangeAsync(entities);
            return await _context.SaveChangesAsync() > 0;
        }


        public async Task<bool> DeleteAsync(TEntity entity)
        {
            Entity.Remove(entity);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            return await Entity.Where(e => e.Id == id).ExecuteDeleteAsync() > 0;
        }

        public virtual Task<bool> DeleteRangeAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return Entity.Where(predicate).ExecuteDeleteAsync().ContinueWith(task => task.Result > 0);
        }


        public IQueryable<TEntity> AsQueryable()
        {
            return Entity.AsQueryable();
        }

        public virtual IQueryable<TEntity> Get(Expression<Func<TEntity, bool>> predicate, bool noTracking = true, params Expression<Func<TEntity, object>>[] includes)
        {
            var query = Entity.AsQueryable();

            if (predicate != null)
                query = query.Where(predicate);

            query = ApplyIncludes(query, includes);

            if (noTracking)
            {
                query = query.AsNoTracking();
            }

            return query;
        }

        public virtual async Task<List<TEntity>> GetAllAsync(bool noTracking = true)
        {
            if (noTracking)
            {
                return await Entity.AsNoTracking().ToListAsync();
            }

            return await Entity.ToListAsync();
        }

        public virtual async Task<List<TEntity>> GetList(Expression<Func<TEntity, bool>> predicate, bool noTracking = true, IOrderedQueryable<TEntity>? orderBy = null, params Expression<Func<TEntity, object>>[] includes)
        {
            IQueryable<TEntity> query = Entity;

            if (predicate != null)
            {
                query = query.Where(predicate);
            }

            foreach (var include in includes)
            {
                query = query.Include(include);
            }

            if (orderBy != null)
            {
                query = query.OrderByDescending(i => i.Id);
            }

            if (noTracking)
            {
                query = query.AsNoTracking();
            }

            return await query.ToListAsync();
        }

        public virtual async Task<TEntity> GetByIdAsync(int id, bool noTracking = true, params Expression<Func<TEntity, object>>[] includes)
        {
            IQueryable<TEntity> query = Entity;

            // No-Tracking modunu ayarla
            if (noTracking)
            {
                query = query.AsNoTracking();
            }

            // İlişkileri dahil et
            foreach (var include in includes)
            {
                query = query.Include(include);
            }

            // ID ile veriyi bul
            return await query.SingleOrDefaultAsync(e => e.Id == id);
        }


        public virtual async Task<TEntity> GetSingleAsync(Expression<Func<TEntity, bool>> predicate, bool noTracking = true, params Expression<Func<TEntity, object>>[] includes)
        {
            IQueryable<TEntity> query = Entity;
            if (predicate != null)
            {
                query = query.Where(predicate);
            }
            query = ApplyIncludes(query, includes);
            if (noTracking)
            {
                query = query.AsNoTracking();
            }
            return await query.SingleOrDefaultAsync();
        }
        private static IQueryable<TEntity> ApplyIncludes(IQueryable<TEntity> query, params Expression<Func<TEntity, object>>[] includes)
        {
            if (includes != null)
            {
                foreach (var item in includes)
                {
                    query = query.Include(item);
                }
            }

            return query;
        }

        public virtual async Task<bool> UpdateAsync(TEntity entity)
        {
            this.Entity.Attach(entity);
            _context.Entry(entity).State = EntityState.Modified;
            return await _context.SaveChangesAsync() > 0;
        }
       
    }
}
