using Configurations.Rules.Interface.Task;
using Gesi.Core.Web.Helper;
using Gesi.Core.Web.WebControllers;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;

namespace Business.Api.Controllers
{
    public class Upload2Controller : WebApiController
    {
        private readonly IUploadsTask _process;

        public Upload2Controller(IUploadsTask process)
        {
            _process = process;
        }

        [HttpPost]
        [AllowAnonymous]
        public HttpResponseMessage Post(HttpRequestMessage item)
        {
            if (!Request.Content.IsMimeMultipartContent())
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);

            var RQ = HttpContext.Current.Request.QueryString;
            // This illustrates how to get the file names.
            HttpFileCollection _Files = HttpContext.Current.Request.Files;
            for (int i = 0; i <= _Files.Count - 1; i++)
            {
                var filename = _Files[i].FileName;

                Stream fileStream = _Files[i].InputStream;
                var mStreamer = new MemoryStream();
                mStreamer.SetLength(fileStream.Length);
                fileStream.Read(mStreamer.GetBuffer(), 0, (int)fileStream.Length);
                mStreamer.Seek(0, SeekOrigin.Begin);
                byte[] fileBytes = mStreamer.GetBuffer();
                _process.Save(RQ[Constants.QueryString.Type], fileBytes, UpdatedId, filename);
            }
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [AllowAnonymous]
        public HttpResponseMessage Get(string id)
        {
            //TODO: la clase statica chetckif tiene que retornar para los mensajes de esta forma HttpResponseMessage
            var item = _process.Get(id, UpdatedId);
            if (item == null)
                return Request.CreateResponse(HttpStatusCode.NoContent);

            var name = item.FileName.Substring(0, item.FileName.IndexOf("."));

            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StreamContent(new MemoryStream(item.Body));
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
            return response;
        }

        [HttpDelete]
        [AllowAnonymous]
        public HttpResponseMessage Delete([FromUri]string id)
        {
            _process.Delete(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}