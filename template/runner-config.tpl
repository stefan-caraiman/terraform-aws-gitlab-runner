concurrent = ${runners_concurrent}
check_interval = ${runners_check_interval}
sentry_dsn = "${sentry_dsn}"
log_format = "json"
listen_address = "${prometheus_listen_address}"

[[runners]]
  name = "${runners_name}"
  url = "${gitlab_url}"
  clone_url = "${gitlab_clone_url}"
  token = "${runners_token}"
  executor = "${runners_executor}"
  environment = ${runners_environment_vars}
  pre_build_script = ${runners_pre_build_script}
  post_build_script = ${runners_post_build_script}
  pre_clone_script = ${runners_pre_clone_script}
  request_concurrency = ${runners_request_concurrency}
  output_limit = ${runners_output_limit}
  limit = ${runners_limit}
  [runners.docker]
    tls_verify = false
    image = "${runners_image}"
    privileged = ${runners_privileged}
    disable_cache = ${runners_disable_cache}
    volumes = ["/cache"${runners_additional_volumes}]
    extra_hosts = ${jsonencode(runners_extra_hosts)}
    shm_size = ${runners_shm_size}
    pull_policy = ${runners_pull_policies}
    runtime = "${runners_docker_runtime}"
    helper_image = "${runners_helper_image}"
    ${runners_docker_services}
  [runners.docker.tmpfs]
    ${runners_volumes_tmpfs}
  [runners.docker.services_tmpfs]
    ${runners_services_volumes_tmpfs}
  [runners.cache]
    Type = "s3"
    Shared = ${shared_cache}
    [runners.cache.s3]
      AuthenticationType = "${auth_type}"
      ServerAddress = "s3.amazonaws.com"
      BucketName = "${bucket_name}"
      BucketLocation = "${aws_region}"
      Insecure = false
  [runners.machine]
    IdleCount = ${runners_idle_count}
    IdleTime = ${runners_idle_time}
    ${runners_max_builds}
    MachineDriver = "amazonec2"
    MachineName = "${docker_machine_name}"
    MachineOptions = [
      "engine-install-url='https://releases.rancher.com/install-docker/20.10.21.sh'",
      "amazonec2-instance-type=${runners_instance_type}",
      "amazonec2-region=${aws_region}",
      "amazonec2-zone=${runners_aws_zone}",
      "amazonec2-vpc-id=${runners_vpc_id}",
      "amazonec2-subnet-id=${runners_subnet_id}",
      "amazonec2-private-address-only=${runners_use_private_address_only}",
      "amazonec2-use-private-address=${runners_use_private_address}",
      "amazonec2-request-spot-instance=${runners_request_spot_instance}",
      "amazonec2-spot-price=${runners_spot_price_bid}",
      "amazonec2-security-group=${runners_security_group_name}",
      "amazonec2-tags=${runners_tags},__PARENT_TAG__",
      "amazonec2-use-ebs-optimized-instance=${runners_ebs_optimized}",
      "amazonec2-monitoring=${runners_monitoring}",
      "amazonec2-iam-instance-profile=%{ if runners_iam_instance_profile_name != "" }${runners_iam_instance_profile_name}%{ else }${runners_instance_profile}%{ endif ~}",
      "amazonec2-root-size=${runners_root_size}",
      "amazonec2-volume-type=${runners_volume_type}",
      "amazonec2-userdata=/etc/gitlab-runner/runners_userdata.sh",
      "amazonec2-ami=${runners_ami}"
      ${docker_machine_options}
    ]

${runners_machine_autoscaling}
