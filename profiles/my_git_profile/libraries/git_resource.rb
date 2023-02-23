class Git < Inspec.resource(1)
    name 'git'

    def initialize(path)
        @path = path
    end

    def branches
        inspec.command("git --git-dir #{@path} branch").stdout
    end

end