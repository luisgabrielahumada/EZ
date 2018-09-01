using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using System;

namespace Terminals.Services.Rules.Model
{
    public class RankRate : BaseModel
    {
        public float Minimum { get; set; }

        public float Maximum { get; set; }

        public float Rate { get; set; }
    }
}