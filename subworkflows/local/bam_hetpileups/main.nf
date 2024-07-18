//
// BAM HETPILEUPS
//

include { HETPILEUPS } from '../../../modules/local/hetpileups/main.nf'

hapmap_sites         = WorkflowNfcasereports.create_file_channel(params.hapmap_sites)
filter               = WorkflowNfcasereports.create_value_channel(params.filter_hets)
max_depth            = WorkflowNfcasereports.create_value_channel(params.max_depth)

workflow BAM_HETPILEUPS {
    // defining inputs
    take:
    input                                             // required: Format should be [meta, tumor bam, normal bam] : BAM only!!!

    //Creating empty channels for output
    main:
    versions            = Channel.empty()
    het_pileups_wgs     = Channel.empty()

    //Remapping the input based on Hetpileups module
    bam_hets = input.map { meta, normal_bam, normal_bai, tumor_bam, tumor_bai ->
        [meta, tumor_bam, tumor_bai, normal_bam, normal_bai]
    }

    HETPILEUPS(bam_hets, filter, max_depth, hapmap_sites)

    // initializing outputs from fragcounter
    versions          = HETPILEUPS.out.versions
    het_pileups_wgs   = HETPILEUPS.out.het_pileups_wgs

    //
    emit:
    het_pileups_wgs

    versions
}
