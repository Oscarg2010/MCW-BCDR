namespace ContosoInsurance.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Dependent
    {
        public int Id { get; set; }

        public int PersonId { get; set; }

        public int PolicyHolderId { get; set; }

        public bool Active { get; set; }

        public virtual Person Person { get; set; }
    }
}
