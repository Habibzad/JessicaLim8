require_relative "./cloud_types"

class CommentGenerator
  WORD_CLOUD_URL = 'https://raw.githubusercontent.com/JessicaLim8/JessicaLim8/master/wordcloud/wordcloud.png'
  ADDWORD = 'add'
  SHUFFLECLOUD = 'shuffle'
  WORDS_INITALIZED = 3

  def initialize(octokit:)
    @octokit = octokit
  end

  def generate
    current_contributors = Hash.new(0)
    current_words_added = WORDS_INITALIZED

    octokit.issues.each do |issue|
      if issue.title.split('|')[1] != SHUFFLECLOUD && issue.labels.any? { |label| label.name == CloudTypes::CLOUDLABELS[-2] }
        current_words_added += 1
        current_contributors[issue.user.login] += 1
      end
    end

    markdown = <<~HTML

    ## Thanks for participating in our latest community word cloud!
    **To keep contributing [add another word](https://github.com/JessicaLim8) to the NEW word cloud**

    ![Word Cloud Words Badge](https://img.shields.io/badge/Words%20in%20#{CloudTypes::CLOUDLABELS[-2]}%20cloud-#{current_words_added}-informational?labelColor=7D898B)
    ![Word Cloud Contributors Badge](https://img.shields.io/badge/Contributors%20in%20#{CloudTypes::CLOUDLABELS[-2]}%20cloud-#{current_contributors.size}-blueviolet?labelColor=7D898B)

    Check out the final product!

    <div align="center">

      ## #{CloudTypes::CLOUDPROMPTS[-2]}

      <img src="#{"https://raw.githubusercontent.com/JessicaLim8/JessicaLim8/master/previous_clouds/#{CloudTypes::CLOUDLABELS[-2]}_cloud#{CloudTypes::CLOUDLABELS.size - 2}.png"}}" alt="WordCloud" width="100%">
    </div>

    #### Thanks to all the contributors

    HTML

    current_contributors.each do |username, count|
      markdown.concat("@#{username}\n")
    end

    markdown

  end

  private

  attr_reader :octokit

end