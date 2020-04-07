using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace DemoClaimsApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
				.ConfigureAppConfiguration((context, config) => {
					var builtConfig = config.Build();
				
					if (context.HostingEnvironment.IsProduction())
					{
						config.AddAzureKeyVault($"https://{builtConfig["KeyVaultName"]}.vault.azure.net/");
					}
					else
					{
						config.AddUserSecrets<Startup>();
					}
					
				})
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
