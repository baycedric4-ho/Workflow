package com.workflow.app.model

data class BuildFlavor(
    val id: String,
    val name: String,
    val apkFlavor: String,
    val targetArch: String,
    val description: String,
    val isChromebook: Boolean = false,
    val isConfiguredInCI: Boolean = true
)

data class WorkflowFile(
    val name: String,
    val path: String,
    val description: String,
    val keyJobs: List<String>
)

data class ReleaseItem(
    val version: String,
    val title: String,
    val highlights: List<String>,
    val date: String
)
