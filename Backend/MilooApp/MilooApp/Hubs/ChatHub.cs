using DataAccessLayer.Context;
using EntityLayer.Entites;
using Microsoft.AspNetCore.SignalR;

namespace MilooApp.Hubs
{
    public class ChatHub(ApplicationDbContext context) : Hub
    {
        public static readonly Dictionary<string,int> Users = new();

        public async Task Connect(int userId)
        {
            Users.Add(Context.ConnectionId, userId);
            User? user = await context.Users.FindAsync(userId);
            if (user is not null)
            {
                user.Status = "online";
                await context.SaveChangesAsync();

                await Clients.All.SendAsync("Users", user);
            }
            Console.WriteLine($"User {user?.FirstName} connected");
        }
        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            Users.TryGetValue(Context.ConnectionId, out int userId);
            Users.Remove(Context.ConnectionId);
            User? user = await context.Users.FindAsync(userId);

            if (user is not null)
            {
                user.Status = "offline";
                await context.SaveChangesAsync();

                await Clients.All.SendAsync("Users", user);
            }
            Console.WriteLine($"User {user?.FirstName} disconnected");
        }

    }
}
