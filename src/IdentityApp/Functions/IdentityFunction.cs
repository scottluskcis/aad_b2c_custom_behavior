using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using IdentityApp.Models;
using System.Net;

namespace IdentityApp.Functions
{
    public static class IdentityFunction
    {
        [FunctionName("IdentityFunction")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "identity")] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function 'IdentityFunction' processed a request.");

            try{
                var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
                var inputClaims = JsonConvert.DeserializeObject<InputClaimsModel>(requestBody);
                log.LogInformation("data received - {json}", requestBody);

                // validation example - used for signup
                if(inputClaims?.FirstName?.ToLower() == "test") 
                    throw new ArgumentException("Invalid First Name was specified");
            
                // claims enrichment example sending back claims, can come from whatever data source
                var outputClaims = new OutputClaimsModel
                {
                    LoyaltyNumber = Guid.NewGuid().ToString(),
                    AccountId = inputClaims.AccountId // tech echo back query string
                };

                log.LogInformation("sending output claims");

                return new OkObjectResult(outputClaims);
            }
            catch(ArgumentException argEx)
            {
                return new ConflictObjectResult(new B2CResponseContent(
                    argEx.Message,
                    HttpStatusCode.Conflict));
            }
            catch(Exception ex)
            {
                return new BadRequestObjectResult(new B2CResponseContent(
                    ex.Message,
                    HttpStatusCode.InternalServerError));
            }
        }
    }
}
