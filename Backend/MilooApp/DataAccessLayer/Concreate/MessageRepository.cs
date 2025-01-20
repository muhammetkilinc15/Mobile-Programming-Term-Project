using DataAccessLayer.Abstract;
using DataAccessLayer.Context;
using EntityLayer.Entites;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Concreate
{
    public class MessageRepository : GenericRepository<Message>, IMessageRepository
    {
        public MessageRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<List<Message>> GetMessagesByUserId(int userId)
        {
            return await _context.Messages
                .Where(x => x.SenderId == userId || x.ReceiverId == userId)
                .Include(x => x.Sender)
                .Include(x => x.Receiver)
                .ToListAsync();
        }

        public async Task<List<Message>> GetMessagesBetweenUsers(int userId, int toUserId, CancellationToken cancellationToken)
        {
            return await _context.Messages
                .Where(p =>
                    (p.SenderId == userId && p.ReceiverId == toUserId) ||
                    (p.ReceiverId == userId && p.SenderId == toUserId))
                .OrderBy(p => p.SentOn)
                .ToListAsync(cancellationToken);
        }
    }
}
