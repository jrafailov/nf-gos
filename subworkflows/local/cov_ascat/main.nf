//
// ASCAT
//

include { ASCAT_SEG } from '../../../modules/local/ascat/main'
include { EXTRACT_PURITYPLOIDY } from '../../../modules/local/ascat/main'

field                  = WorkflowNfcasereports.create_value_channel(params.field_ascat)
hets_threshold         = WorkflowNfcasereports.create_value_channel(params.hets_thresh_ascat)
penalty                = WorkflowNfcasereports.create_value_channel(params.penalty_ascat)
gc_correct             = WorkflowNfcasereports.create_value_channel(params.gc_correct_ascat)
rebin_width            = WorkflowNfcasereports.create_value_channel(params.rebin_width_ascat)
from_maf               = WorkflowNfcasereports.create_value_channel(params.from_maf_ascat)

workflow COV_ASCAT {

    take:
    inputs              // [ meta, hets, cbs_cov ]

    main:
    versions     = Channel.empty()
    pp           = Channel.empty()
    seg          = Channel.empty()
    purity       = Channel.empty()
    ploidy       = Channel.empty()

    ASCAT_SEG(inputs, field, hets_threshold, penalty, gc_correct, rebin_width, from_maf)

    ascat_pp = Channel.empty().mix(ASCAT_SEG.out.purityploidy)
    EXTRACT_PURITYPLOIDY(ascat_pp)

    versions     = versions.mix(ASCAT_SEG.out.versions)
    pp           = pp.mix(ASCAT_SEG.out.purityploidy)
    seg          = seg.mix(ASCAT_SEG.out.segments)
    purity       = purity.mix(EXTRACT_PURITYPLOIDY.out.purity_val)
    ploidy       = ploidy.mix(EXTRACT_PURITYPLOIDY.out.ploidy_val)

    emit:
    pp                                                 // only need to emit the purityploidy for JaBbA
    purity
    ploidy

    versions
}
