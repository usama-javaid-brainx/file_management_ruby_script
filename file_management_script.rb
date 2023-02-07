class Node
    attr_accessor :name, :size, :children
    
    def initialize(name)
        @size = 0
        @name = name
        @children = []
    end
end

class DirectoryTree
    
    attr_accessor :traversed_directories_list, :root_directory, :current_directory, :total_size_of_deletable_directories

    def initialize(name)
        @traversed_directories_list = []
        @root_directory = Node.new(name)   
        @current_directory = @root_directory
        @total_size_of_deletable_directories = 0
    end

    def insert(name) 
        @current_directory.children << Node.new(name)
    end

    def find_and_set_current_directory(node = @root_directory)
        if node.name == @traversed_directories_list.last
            @current_directory = node
            return
        else
            node.children.each do |child|
                find_and_set_current_directory(child)    
            end
        end
    end

    def print_directory_tree(node = @root_directory)
        puts "Directory: #{node.name}"
        puts "   Size: #{node.size}"
        puts "   Child Directorires: "
        node.children.each do |child|
            print_directory_tree(child)    
        end
    end

    def print_deletable_directories(node = @root_directory)
        if node.size <= 100000
            puts "Directory: #{node.name}"
            puts "   Size: #{node.size}"
            @total_size_of_deletable_directories += node.size
        end 
        
        node.children.each do |child|
            print_deletable_directories(child)    
        end
    end

    def update_parent_child_size(file_size, node = @root_directory )
         if (node.name == '/') || @traversed_directories_list.include?(node.name)
            node.size += file_size
         end
            node.children.each do |child|
                update_parent_child_size(file_size , child)    
            end
    end
end

puts "Script running"
directory_tree = DirectoryTree.new('/')
File.open("input.txt").each do |line_text|
    if line_text.include?('$ cd ..')
        directory_tree.traversed_directories_list.pop() 
    elsif line_text.include?('$ cd')
        directory_name = line_text[5..].strip
        unless directory_name == directory_tree.current_directory.name
            directory_tree.traversed_directories_list << directory_name
            directory_tree.insert(directory_name)
            directory_tree.find_and_set_current_directory    
        end
    elsif !(line_text.gsub(/[^\d]/, '').empty?)
        directory_tree.update_parent_child_size(line_text.gsub(/[^\d]/, '').to_i)
    end  
end

puts "Deletable Directories List: \n"
       
directory_tree.print_deletable_directories

puts "\nTotal Size: #{directory_tree.total_size_of_deletable_directories}"