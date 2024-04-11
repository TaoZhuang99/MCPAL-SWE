% =========================================================================
% Self defined figure styles
% =========================================================================
classdef Figure < handle

	properties
		% handle of figure
		hFigure = nan;
		% handle of axes
        hAxes = nan;
		% handle of lines
        hLines = nan;
		% handle of colorbar
        hColorbar = nan;
		% handle of legend
		hLegend = nan;
		% 'line', 'surface'
        figureType = nan;
	end

	methods
		function obj = Figure()
			obj.hFigure = figure();           
        end

		% ==================================================
		% Generate JPEG files
		% --------------------------------------------------
		% INPUT
		%	fn		--- The JPEG file name. [cache]
        %   'resolution'
        %           --- [300] 
		% ==================================================
		function Print(~, fn, varargin)
			p = inputParser;
			addParameter(p, 'resolution', 600);
			parse(p, varargin{:});
			ip = p.Results;

			if ~exist('fn', 'var')
				fn = 'cache';
            end
			print(sprintf('%s.jpg', fn),'-djpeg', sprintf('-r%s',num2str(ip.resolution)));
        end

        function Init(obj)
            % obj.hAxes = obj.hFigure.CurrentAxes;
            if ~isempty(obj.hAxes)
                obj.figureType = obj.hAxes.Children.Type;
            end
            
			switch obj.figureType
				% 如普通的曲线图
				case 'line'
					obj.hLines = obj.hAxes.Children;
				% 如pcolor
				case 'surface'
					shading interp
					colormap jet
					obj.hColorbar = colorbar;
            end

            % 初始化尺寸为 normal
            if ~isempty(obj.hAxes)
				obj.SetSize;
            end

        end
            
		function SetSize(obj, sizeType)
			if ~exist('sizeType', 'var')
				sizeType = 'normal';
			end
			
% 			FONT_NAME = 'Times New Roman';
            FONT_NAME = 'Helvetica';
            % FONT_NAME = 'CMU Serif';
			switch sizeType
				case 'normal'
					FONT_SIZE = 16;
					MARKER_SIZE = 10;
					LINE_WIDTH = 2;
				case 'big'
					FONT_SIZE = 24;
% 					FONT_SIZE = 22;
% 					MARKER_SIZE = 14;
					MARKER_SIZE = 16;
					LINE_WIDTH = 2;
				case 'large'
					FONT_SIZE = 30;
					MARKER_SIZE = 18;
					LINE_WIDTH = 4;
				case 'huge'
					FONT_SIZE = 40;
					MARKER_SIZE = 20;
					LINE_WDITH = 3;
				otherwise
					;
			end
			grid on;
            obj.hAxes.FontSize = FONT_SIZE;
% 			obj.hFig.CurrentAxes.FontSize = FONT_SIZE;
% 			set(obj.hFig.Children, 'FontSize', FONT_SIZE);
            obj.hAxes.FontName = FONT_NAME;
% 			set(obj.hFig.Children, 'FontName', FONT_NAME);
			switch obj.figureType
				case 'line'
					for i = 1:length(obj.hLines)
						obj.hLines(i).LineWidth = LINE_WIDTH;
                        obj.hLines(i).MarkerSize = MARKER_SIZE;
					end
            end
        end
        
        function SetAxesAspectRatio(obj, mode)
			if ~exist('type', 'var')
				mode = 'equal';
			end
			% equal 
			switch mode
				% xy轴按比例显示
				case 'equal' 
					aspectRatio0 = (obj.hFigure.CurrentAxes.XLim(2)-...
						obj.hFigure.CurrentAxes.XLim(1))/...
						(obj.hFigure.CurrentAxes.YLim(2)-...
						obj.hFigure.CurrentAxes.YLim(1));
				otherwise
					;
			end

%             aspectRatio1 = obj.hFig.CurrentAxes.Position(3)/...
%                 obj.hFig.CurrentAxes.Position(4) * ...
%                 obj.hFig.Position(3) /...
%                 obj.hFig.Position(4);
            
            pbaspect([1*aspectRatio0,1,1])
        end
        
		% 自动更新 legend
		function hLegend = get.hLegend(obj)
			hLegend.Interpreter = nan;
			for i = 1:length(obj.hFigure.Children)
				if strcmp(obj.hFigure.Children(i).Type, 'legend')
					hLegend = obj.hFigure.Children(i);
                    hLegend.Interpreter = 'latex';
				end
			end
			
		end

		function hAxes = get.hAxes(obj)
			hAxes = obj.hFigure.CurrentAxes;
            % hAxes.XLabel.Interpreter = 'latex';
            % hAxes.YLabel.Interpreter = 'latex';
		end

        function SetColorbarTitle(obj, title_str)
            for i = 1:length(obj.hFigure.Children)
                if strcmp(obj.hFigure.Children(i).Type, 'colorbar')
                    obj.hFigure.Children(i).Title.String = title_str;
                end
            end
        end

		function setLineColor(obj)
			for i = 1:length(obj.hLines)
				obj.hLines(i).Color = Color.CELL{length(obj.hLines)-i+1};
			end
        end
        
        function ExportTikz(obj, varargin)
            ip = inputParser();
            ip.addParameter('filename', []);
            ip.parse(varargin{:});
            ip = ip.Results;
            
            if ~isempty(ip.filename)
                matlab2tikz('figurehandle', obj.hFigure, 'standalone', true, ...
                    ip.filename);
            else
                matlab2tikz('figurehandle', obj.hFigure, 'standalone', true, ...
                    varargin);
            end
        end
	end

end
