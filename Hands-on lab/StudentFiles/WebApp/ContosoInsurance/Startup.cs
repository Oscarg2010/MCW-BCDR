using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ContosoInsurance.Startup))]
namespace ContosoInsurance
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
