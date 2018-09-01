using System;

namespace Bussines.ViewModel
{
    public class AvaliableVesselModel
    {
        public DateTime NextOpeningOn { get; set; }
        public DateTime NextOpeningPort { get; set; }
        public int CurrentPortId { get; set; }
        public int CurrentTerminalId { get; set; }
        public Guid Token { get; set; }
    }
}