require 'spec_helper'

describe 'omsa' do

  on_supported_os.each do |os, facts|
    context "on #{os} - Dell" do
      let(:facts) do
        facts.merge({
          :manufacturer => 'Dell Inc.',
        })
      end

      it { should compile.with_all_deps }

      it { should create_class('omsa') }
      it { should contain_class('omsa::params') }

      it { should contain_anchor('omsa::begin').that_comes_before('Class[omsa::repo]') }
      it { should contain_class('omsa::repo').that_comes_before('Class[omsa::install]') }
      it { should contain_class('omsa::install').that_comes_before('Class[omsa::service]') }
      it { should contain_class('omsa::service').that_comes_before('Anchor[omsa::end]') }
      it { should contain_anchor('omsa::end') }

      case facts[:osfamily]
      when 'RedHat'
        context 'omsa::repo' do
          it { should contain_anchor('omsa::repo::begin').that_comes_before('Class[omsa::repo::el]') }
          it { should contain_class('omsa::repo::el').that_comes_before('Anchor[omsa::repo::end]') }
          it { should contain_anchor('omsa::repo::end') }
        end

        context 'omsa::repo::el' do
          it do
            should contain_yumrepo('dell-omsa-indep').with({
              :descr          => 'Dell OMSA repository - Hardware independent',
              :baseurl        => 'absent',
              :mirrorlist     => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver',
              :enabled        => '1',
              :gpgcheck       => '1',
              :gpgkey         => 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios',
              :failovermethod => 'priority',
            })
          end

          it do
            should contain_package('yum-dellsysid').with({
              :ensure   => 'present',
              :require  => 'Yumrepo[dell-omsa-indep]',
            })
          end

          context 'when use_mirror => false' do
            let(:params) {{ :use_mirror => false }}
            case os
            when /-5-/
              baseurl = 'http://linux.dell.com/repo/hardware/latest/platform_independent/rh50_64/'
            when /-6-/
              baseurl = 'http://linux.dell.com/repo/hardware/latest/platform_independent/rh60_64/'
            when /-7-/
              baseurl = 'http://linux.dell.com/repo/hardware/latest/platform_independent/rh70_64/'
            end

            it { should contain_yumrepo('dell-omsa-indep').with_baseurl(baseurl) }
            it { should contain_yumrepo('dell-omsa-indep').with_mirrorlist('absent') }
          end
        end
      end

      context 'omsa::install' do
        it { should contain_package('srvadmin-all').with_ensure('present') }
        it { should_not contain_package('srvadmin-omcommon') }
        it { should_not contain_package('srvadmin-omacore') }

        context 'when install_type => minimal' do
          let(:params) {{ :install_type => 'minimal' }}

          it { should_not contain_package('srvadmin-all') }
          it { should contain_package('srvadmin-omcommon').with_ensure('present').that_comes_before('Package[srvadmin-omacore]') }
          it { should contain_package('srvadmin-omacore').with_ensure('present') }
        end
      end

      context 'omsa::service' do
        it do
          should contain_service('srvadmin-services').with({
            :ensure   => 'running',
            :enable   => nil,
            :restart  => '/opt/dell/srvadmin/sbin/srvadmin-services.sh restart',
            :start    => '/opt/dell/srvadmin/sbin/srvadmin-services.sh start && /opt/dell/srvadmin/sbin/srvadmin-services.sh enable',
            :status   => '/opt/dell/srvadmin/sbin/srvadmin-services.sh status',
            :stop     => '/opt/dell/srvadmin/sbin/srvadmin-services.sh stop && /opt/dell/srvadmin/sbin/srvadmin-services.sh disable',
          })
        end
      end
    end

    context "on #{os} - non-Dell" do
      let(:facts) do
        facts.merge({
          :manufacturer => 'Supermicro',
        })
      end

      it { should compile.with_all_deps }

      it { should create_class('omsa') }
      it { should contain_class('omsa::params') }

      it { should_not contain_anchor('omsa::begin') }
      it { should_not contain_class('omsa::repo') }
      it { should_not contain_class('omsa::install') }
      it { should_not contain_class('omsa::service') }
      it { should_not contain_anchor('omsa::end') }
    end
  end
end
