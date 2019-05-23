namespace ContosoInsurance.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class PolicyHolder
    {
        public int Id { get; set; }

        public int PersonId { get; set; }

        public bool Active { get; set; }

        [Column(TypeName = "date")]
        public DateTime? StartDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? EndDate { get; set; }

        [Required]
        [StringLength(50)]
        public string Username { get; set; }

        [StringLength(50)]
        public string PolicyNumber { get; set; }

        public int PolicyId { get; set; }

        [StringLength(500)]
        public string FilePath { get; set; }

        [Column(TypeName = "money")]
        public decimal PolicyAmount { get; set; }

        [Column(TypeName = "money")]
        public decimal Deductible { get; set; }

        [Column(TypeName = "money")]
        public decimal OutOfPocketMax { get; set; }

        [Column(TypeName = "date")]
        public DateTime EffectiveDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime ExpirationDate { get; set; }

        public virtual Person Person { get; set; }

        public virtual Policy Policy { get; set; }
    }
}
