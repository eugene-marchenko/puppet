Feature: varnish/config.pp
  In order to varnishor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: varnish::config default
    Given a node named "varnish-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/varnish/secret"
    And there should be a file "/etc/varnish/default.vcl"
      And the file should contain /^probe backend_health_check \{\n/
      And the file should contain /^    .url = "/ping.txt";\n/
      And the file should contain /^    .timeout = 300ms;\n/
      And the file should contain /^    .interval = 1s;\n/
      And the file should contain /^    .window = 10;\n/
      And the file should contain /^    .threshold = 6;\n/
      And the file should contain /^    .expected_response = 200;\n\}\n/
      And the file should contain /^backend backend0 \{/
      And the file should contain /^    .host = "localhost"/
      And the file should contain /^    .port = "80"/
      And the file should contain /^    .first_byte_timeout = 10s/
      And the file should contain /^    .probe = backend_health_check/
      And the file should contain /^director default round-robin \{\n    \{ .backend = backend0; \}\n\}/
      And the file should contain /^acl purge \{\n    "localhost";\n\}$/
    And there should be a file "/etc/varnish/devicedetect.vcl"
    And there should be a file "/etc/default/varnish"
      And the file should contain /^START=yes/
      And the file should contain /^NFILES=131072/
      And the file should contain /^MEMLOCK=82000/
      And the file should contain /^INSTANCE=varnish-config-default/
      And the file should contain /^VCL_CONF=\/etc\/varnish\/default.vcl/
      And the file should contain /^LISTEN_ADDRESS=/
      And the file should contain /^LISTEN_PORT=6081/
      And the file should contain /^ADMIN_LISTEN_ADDRESS=127.0.0.1/
      And the file should contain /^ADMIN_LISTEN_PORT=6082/
      And the file should contain /^STORAGE_FILE=\/var\/lib\/varnish\/\$INSTANCE\/varnish_storage.bin/
      And the file should contain /^STORAGE_SIZE=1G/
      And the file should contain /^SECRET_FILE=/etc\/varnish\/secret/
      And the file should contain /^STORAGE="file,\$\{STORAGE_FILE\},\$\{STORAGE_SIZE\}"/
      And the file should contain /^AUTO_RESTART=on/
      And the file should contain /^BAN_DUPS=on/
      And the file should contain /^BAN_LURKER_SLEEP=0.01/
      And the file should contain /^BETWEEN_BYTES_TIMEOUT=60/
      And the file should contain /^CLI_BUFFER=8192/
      And the file should contain /^CLI_TIMEOUT=10/
      And the file should contain /^CLOCK_SKEW=10/
      And the file should contain /^CONNECT_TIMEOUT=0.7/
      And the file should contain /^CRITBIT_COOLOFF=180.0/
      And the file should contain /^DEFAULT_GRACE=10/
      And the file should contain /^DEFAULT_KEEP=0/
      And the file should contain /^DEFAULT_TTL=120/
      And the file should contain /^DIAG_BITMAP=0/
      And the file should contain /^ESI_SYNTAX=0/
      And the file should contain /^EXPIRY_SLEEP=1/
      And the file should contain /^FETCH_CHUNKSIZE=128/
      And the file should contain /^FETCH_MAXCHUNKSIZE=262144/
      And the file should contain /^FIRST_BYTE_TIMEOUT=60/
      And the file should contain /^GZIP_LEVEL=6/
      And the file should contain /^GZIP_MEMLEVEL=8/
      And the file should contain /^GZIP_STACK_BUFFER=32768/
      And the file should contain /^GZIP_TMP_SPACE=0/
      And the file should contain /^GZIP_WINDOW=15/
      And the file should contain /^HTTP_GZIP_SUPPORT=on/
      And the file should contain /^HTTP_MAX_HDR=64/
      And the file should contain /^HTTP_RANGE_SUPPORT=on/
      And the file should contain /^HTTP_REQ_HDR_LEN=8192/
      And the file should contain /^HTTP_REQ_SIZE=32768/
      And the file should contain /^HTTP_RESP_HDR_LEN=8192/
      And the file should contain /^HTTP_RESP_SIZE=32768/
      And the file should contain /^LISTEN_DEPTH=1024/
      And the file should contain /^LOG_HASHSTRING=on/
      And the file should contain /^LOG_LOCAL_ADDRESS=off/
      And the file should contain /^LRU_INTERVAL=2/
      And the file should contain /^MAX_ESI_DEPTH=5/
      And the file should contain /^MAX_RESTARTS=4/
      And the file should contain /^NUKE_LIMIT=50/
      And the file should contain /^PING_INTERVAL=3/
      And the file should contain /^PIPE_TIMEOUT=60/
      And the file should contain /^PREFER_IPV6=off/
      And the file should contain /^QUEUE_MAX=100/
      And the file should contain /^RUSH_EXPONENT=3/
      And the file should contain /^SAINTMODE_THRESHOLD=10/
      And the file should contain /^SEND_TIMEOUT=60/
      And the file should contain /^SESS_TIMEOUT=5/
      And the file should contain /^SESS_WORKSPACE=65536/
      And the file should contain /^SESSION_LINGER=50/
      And the file should contain /^SESSION_MAX=100000/
      And the file should contain /^SHM_RECLEN=255/
      And the file should contain /^SHM_WORKSPACE=8192/
      And the file should contain /^SHORTLIVED=10.0/
      And the file should contain /^SYSLOG_CLI_TRAFFIC=on/
      And the file should contain /^THREAD_POOL_ADD_DELAY=2/
      And the file should contain /^THREAD_POOL_ADD_THRESHOLD=2/
      And the file should contain /^THREAD_POOL_FAIL_DELAY=200/
      And the file should contain /^THREAD_POOL_MAX=500/
      And the file should contain /^THREAD_POOL_MIN=5/
      And the file should contain /^THREAD_POOL_PURGE_DELAY=1000/
      And the file should contain /^THREAD_POOL_STACK=-1/
      And the file should contain /^THREAD_POOL_TIMEOUT=300/
      And the file should contain /^THREAD_POOL_WORKSPACE=65536/
      And the file should contain /^THREAD_POOLS=2/
      And the file should contain /^THREAD_STATS_RATE=10/
      And the file should contain /^VCC_ERR_UNREF=on/
      And the file should contain /^VCL_DIR=\/etc\/varnish/
      And the file should contain /^VCL_TRACE=off/
      And the file should contain /^VMOD_DIR=\/usr\/lib\/varnish\/vmods/
    And there should be a file "/etc/default/varnishncsa"
      And the file should contain /^VARNISHNCSA_ENABLED=1/
    And there should be a file "/etc/default/varnishlog"
      And the file should contain /^# VARNISHLOG_ENABLED=1/
    And there should be a script "/etc/init.d/varnishncsa"
    And there should be a script "/etc/init.d/varnishlog"
    And file "/etc/logrotate.d/varnish" should be "absent"
    And following directories should be created:
      | name                |
      | /etc/varnish/errors |
    And there should be a file "/etc/varnish/errors/500.html"

    Scenario: varnish::config from facts
    Given a node named "varnish-config-default"
    And a fact "varnish_backends" of "foo.bar.com, baz.bar.com:8080"
    And a fact "varnish_backend_health_check_url" of "/healthcheck"
    And a fact "varnish_backend_health_check_timeout" of "1s"
    And a fact "varnish_backend_health_check_interval" of "5s"
    And a fact "varnish_backend_health_check_window" of "5"
    And a fact "varnish_backend_health_check_threshold" of "3"
    And a fact "varnish_backend_health_check_expected_response" of "304"
    And a fact "varnish_backend_first_byte_timeout" of "5s"
    And a fact "varnish_purge_acls" of "'10.0.0.0'/8,'localhost'"
    And a fact "varnish_ncsa_log_enabled" of "false"
    And a fact "varnish_log_enabled" of "yes"
    And a fact "varnish_enabled" of "no"
    And a fact "varnish_openfile_limit" of "1024"
    And a fact "varnish_memlock_limit" of "64"
    And a fact "varnish_listen_address" of "127.0.0.1"
    And a fact "varnish_listen_port" of "80"
    And a fact "varnish_admin_listen_address" of "localhost"
    And a fact "varnish_admin_listen_port" of "8080"
    And a fact "varnish_storage_file" of "/mnt/varnish_storage.bin"
    And a fact "varnish_storage_size" of "60%"
    And a fact "varnish_secret_file" of "/etc/varnish/secret2"
    And a fact "varnish_auto_restart" of "off"
    And a fact "varnish_ban_dups" of "off"
    And a fact "varnish_ban_lurker_sleep" of "2.0"
    And a fact "varnish_between_bytes_timeout" of "120"
    And a fact "varnish_cli_buffer" of "4096"
    And a fact "varnish_cli_timeout" of "20"
    And a fact "varnish_clock_skew" of "20"
    And a fact "varnish_connect_timeout" of "1"
    And a fact "varnish_critbit_cooloff" of "240.0"
    And a fact "varnish_default_grace" of "20"
    And a fact "varnish_default_keep" of "2"
    And a fact "varnish_default_ttl" of "30"
    And a fact "varnish_diag_bitmap" of "0x00000002"
    And a fact "varnish_esi_syntax" of "0x00000002"
    And a fact "varnish_expiry_sleep" of "2"
    And a fact "varnish_fetch_chunksize" of "256"
    And a fact "varnish_fetch_maxchunksize" of "8192"
    And a fact "varnish_first_byte_timeout" of "120"
    And a fact "varnish_gzip_level" of "9"
    And a fact "varnish_gzip_memlevel" of "5"
    And a fact "varnish_gzip_stack_buffer" of "65536"
    And a fact "varnish_gzip_tmp_space" of "2"
    And a fact "varnish_gzip_window" of "8"
    And a fact "varnish_http_gzip_support" of "off"
    And a fact "varnish_http_max_hdr" of "128"
    And a fact "varnish_http_range_support" of "off"
    And a fact "varnish_http_req_hdr_len" of "32768"
    And a fact "varnish_http_req_size" of "65536"
    And a fact "varnish_http_resp_hdr_len" of "32768"
    And a fact "varnish_http_resp_size" of "65536"
    And a fact "varnish_listen_depth" of "2048"
    And a fact "varnish_log_hashstring" of "off"
    And a fact "varnish_log_local_address" of "on"
    And a fact "varnish_lru_interval" of "3"
    And a fact "varnish_max_esi_depth" of "10"
    And a fact "varnish_max_restarts" of "5"
    And a fact "varnish_nuke_limit" of "100"
    And a fact "varnish_ping_interval" of "10"
    And a fact "varnish_pipe_timeout" of "120"
    And a fact "varnish_prefer_ipv6" of "on"
    And a fact "varnish_queue_max" of "95"
    And a fact "varnish_rush_exponent" of "4"
    And a fact "varnish_saintmode_threshold" of "20"
    And a fact "varnish_send_timeout" of "120"
    And a fact "varnish_sess_timeout" of "10"
    And a fact "varnish_sess_workspace" of "32768"
    And a fact "varnish_session_linger" of "60"
    And a fact "varnish_session_max" of "1000000"
    And a fact "varnish_shm_reclen" of "256"
    And a fact "varnish_shm_workspace" of "8193"
    And a fact "varnish_shortlived" of "11.0"
    And a fact "varnish_syslog_cli_traffic" of "off"
    And a fact "varnish_thread_pool_add_delay" of "3"
    And a fact "varnish_thread_pool_add_threshold" of "3"
    And a fact "varnish_thread_pool_fail_delay" of "300"
    And a fact "varnish_thread_pool_max" of "1000"
    And a fact "varnish_thread_pool_min" of "50"
    And a fact "varnish_thread_pool_purge_delay" of "2000"
    And a fact "varnish_thread_pool_stack" of "65536"
    And a fact "varnish_thread_pool_timeout" of "400"
    And a fact "varnish_thread_pool_workspace" of "32768"
    And a fact "varnish_thread_pools" of "4"
    And a fact "varnish_thread_stats_rate" of "12"
    And a fact "varnish_vcc_err_unref" of "off"
    And a fact "varnish_vcl_dir" of "/opt/varnish"
    And a fact "varnish_vcl_trace" of "on"
    And a fact "varnish_vmod_dir" of "/opt/varnish/lib/vmods"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/varnish/secret"
    And there should be a file "/etc/varnish/default.vcl"
      And the file should contain /^probe backend_health_check \{\n/
      And the file should contain /^    .url = "/healthcheck";\n/
      And the file should contain /^    .timeout = 1s;\n/
      And the file should contain /^    .interval = 5s;\n/
      And the file should contain /^    .window = 5;\n/
      And the file should contain /^    .threshold = 3;\n/
      And the file should contain /^    .expected_response = 304;\n\}\n/
      And the file should contain /^backend backend0 \{/
      And the file should contain /^    .host = "foo.bar.com"/
      And the file should contain /^    .port = "80"/
      And the file should contain /^    .first_byte_timeout = 5s/
      And the file should contain /^    .probe = backend_health_check/
      And the file should contain /^backend backend1 \{/
      And the file should contain /^    .host = "baz.bar.com"/
      And the file should contain /^    .port = "8080"/
      And the file should contain /^    .first_byte_timeout = 5s/
      And the file should contain /^    .probe = backend_health_check/
      And the file should contain /^director default round-robin \{\n    \{ .backend = backend0; \}\n    \{ .backend = backend1; \}\n\}/
      And the file should contain /^acl purge \{\n    '10.0.0.0'/8;\n    'localhost';\n\}$/
    And there should be a file "/etc/varnish/devicedetect.vcl"
    And there should be a file "/etc/default/varnish"
      And the file should contain /^START=no/
      And the file should contain /^NFILES=1024/
      And the file should contain /^MEMLOCK=64/
      And the file should contain /^INSTANCE=varnish-config-default/
      And the file should contain /^VCL_CONF=\/etc\/varnish\/default.vcl/
      And the file should contain /^LISTEN_ADDRESS=127.0.0.1/
      And the file should contain /^LISTEN_PORT=80/
      And the file should contain /^ADMIN_LISTEN_ADDRESS=localhost/
      And the file should contain /^ADMIN_LISTEN_PORT=8080/
      And the file should contain /^STORAGE_FILE=\/mnt\/varnish_storage.bin/
      And the file should contain /^STORAGE_SIZE=60%/
      And the file should contain /^SECRET_FILE=/etc\/varnish\/secret2/
      And the file should contain /^STORAGE="file,\$\{STORAGE_FILE\},\$\{STORAGE_SIZE\}"/
      And the file should contain /^AUTO_RESTART=off/
      And the file should contain /^BAN_DUPS=off/
      And the file should contain /^BAN_LURKER_SLEEP=2.0/
      And the file should contain /^BETWEEN_BYTES_TIMEOUT=120/
      And the file should contain /^CLI_BUFFER=4096/
      And the file should contain /^CLI_TIMEOUT=20/
      And the file should contain /^CLOCK_SKEW=20/
      And the file should contain /^CONNECT_TIMEOUT=1/
      And the file should contain /^CRITBIT_COOLOFF=240.0/
      And the file should contain /^DEFAULT_GRACE=20/
      And the file should contain /^DEFAULT_KEEP=2/
      And the file should contain /^DEFAULT_TTL=30/
      And the file should contain /^DIAG_BITMAP=0x00000002/
      And the file should contain /^ESI_SYNTAX=0x00000002/
      And the file should contain /^EXPIRY_SLEEP=2/
      And the file should contain /^FETCH_CHUNKSIZE=256/
      And the file should contain /^FETCH_MAXCHUNKSIZE=8192/
      And the file should contain /^FIRST_BYTE_TIMEOUT=120/
      And the file should contain /^GZIP_LEVEL=9/
      And the file should contain /^GZIP_MEMLEVEL=5/
      And the file should contain /^GZIP_STACK_BUFFER=65536/
      And the file should contain /^GZIP_TMP_SPACE=2/
      And the file should contain /^GZIP_WINDOW=8/
      And the file should contain /^HTTP_GZIP_SUPPORT=off/
      And the file should contain /^HTTP_MAX_HDR=128/
      And the file should contain /^HTTP_RANGE_SUPPORT=off/
      And the file should contain /^HTTP_REQ_HDR_LEN=32768/
      And the file should contain /^HTTP_REQ_SIZE=65536/
      And the file should contain /^HTTP_RESP_HDR_LEN=32768/
      And the file should contain /^HTTP_RESP_SIZE=65536/
      And the file should contain /^LISTEN_DEPTH=2048/
      And the file should contain /^LOG_HASHSTRING=off/
      And the file should contain /^LOG_LOCAL_ADDRESS=on/
      And the file should contain /^LRU_INTERVAL=3/
      And the file should contain /^MAX_ESI_DEPTH=10/
      And the file should contain /^MAX_RESTARTS=5/
      And the file should contain /^NUKE_LIMIT=100/
      And the file should contain /^PING_INTERVAL=10/
      And the file should contain /^PIPE_TIMEOUT=120/
      And the file should contain /^PREFER_IPV6=on/
      And the file should contain /^QUEUE_MAX=95/
      And the file should contain /^RUSH_EXPONENT=4/
      And the file should contain /^SAINTMODE_THRESHOLD=20/
      And the file should contain /^SEND_TIMEOUT=120/
      And the file should contain /^SESS_TIMEOUT=10/
      And the file should contain /^SESS_WORKSPACE=32768/
      And the file should contain /^SESSION_LINGER=60/
      And the file should contain /^SESSION_MAX=1000000/
      And the file should contain /^SHM_RECLEN=256/
      And the file should contain /^SHM_WORKSPACE=8193/
      And the file should contain /^SHORTLIVED=11.0/
      And the file should contain /^SYSLOG_CLI_TRAFFIC=off/
      And the file should contain /^THREAD_POOL_ADD_DELAY=3/
      And the file should contain /^THREAD_POOL_ADD_THRESHOLD=3/
      And the file should contain /^THREAD_POOL_FAIL_DELAY=300/
      And the file should contain /^THREAD_POOL_MAX=1000/
      And the file should contain /^THREAD_POOL_MIN=50/
      And the file should contain /^THREAD_POOL_PURGE_DELAY=2000/
      And the file should contain /^THREAD_POOL_STACK=65536/
      And the file should contain /^THREAD_POOL_TIMEOUT=400/
      And the file should contain /^THREAD_POOL_WORKSPACE=32768/
      And the file should contain /^THREAD_POOLS=4/
      And the file should contain /^THREAD_STATS_RATE=12/
      And the file should contain /^VCC_ERR_UNREF=off/
      And the file should contain /^VCL_DIR=\/opt\/varnish/
      And the file should contain /^VCL_TRACE=on/
      And the file should contain /^VMOD_DIR=\/opt/varnish\/lib\/vmods/

    And there should be a file "/etc/default/varnishncsa"
      And the file should contain /^# VARNISHNCSA_ENABLED=1/
    And there should be a file "/etc/default/varnishlog"
      And the file should contain /^VARNISHLOG_ENABLED=1/
    And there should be a script "/etc/init.d/varnishncsa"
    And there should be a script "/etc/init.d/varnishlog"
    And file "/etc/logrotate.d/varnish" should be "absent"
    And following directories should be created:
      | name                |
      | /etc/varnish/errors |
    And there should be a file "/etc/varnish/errors/500.html"

    Scenario: varnish::config no parameters
    Given a node named "varnish-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
